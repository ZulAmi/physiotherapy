"""
Video collector for PhysioFlow
Fetches YouTube videos for training data
"""
from pytube import YouTube
from youtube_search import YoutubeSearch
import json
import os
import argparse
import shutil

def download_videos(search_term, max_results=10, output_dir='ml/data/videos'):
    """Download videos based on search term"""
    print(f"Searching for '{search_term}' videos...")
    results = YoutubeSearch(search_term, max_results=max_results).to_dict()
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir, exist_ok=True)
    
    print(f"Found {len(results)} videos, downloading...")
    for idx, result in enumerate(results):
        try:
            video_id = result['id']
            yt_url = f"https://youtube.com/watch?v={video_id}"
            print(f"Downloading {idx+1}/{len(results)}: {result['title']}")
            
            yt = YouTube(yt_url)
            stream = yt.streams.filter(res="360p", file_extension='mp4').first()
            output_file = os.path.join(output_dir, f"video_{video_id}.mp4")
            
            # Skip if already downloaded
            if os.path.exists(output_file):
                print(f"Video already exists, skipping...")
                continue
                
            stream.download(output_path=output_dir, filename=f"video_{video_id}.mp4")
            
            # Save metadata
            metadata_file = os.path.join(output_dir, f"video_{video_id}_meta.json")
            with open(metadata_file, 'w') as f:
                json.dump({
                    'title': result['title'],
                    'duration': result['duration'],
                    'views': result['views'],
                    'url': yt_url,
                    'search_term': search_term
                }, f, indent=2)
                
        except Exception as e:
            print(f"Failed to download {result['id']}: {str(e)}")

def _download_videos_fallback(self, search_term, max_videos, output_dir):
    """Fallback implementation for video downloading"""
    print("Using fallback video downloader")
    
    # Try multiple download methods
    try:
        # Method 1: Use pytube directly with error handling
        from pytube import YouTube, Search
        from pytube.exceptions import VideoUnavailable, RegexMatchError
        
        # Search for videos
        search_results = Search(search_term).results[:max_videos]
        
        for i, video in enumerate(search_results):
            try:
                print(f"Downloading video {i+1}/{len(search_results)}: {video.title}")
                output_path = os.path.join(output_dir, f"video_{i+1}.mp4")
                
                # Try with different stream selections
                try:
                    # First try progressive stream
                    video.streams.filter(progressive=True, file_extension="mp4").order_by('resolution').desc().first().download(
                        output_path=output_dir, 
                        filename=f"video_{i+1}.mp4"
                    )
                except Exception:
                    # Fallback to audio only if video fails
                    video.streams.filter(only_audio=True).first().download(
                        output_path=output_dir,
                        filename=f"video_{i+1}.mp4"
                    )
                
                # Save metadata
                metadata_file = os.path.join(output_dir, f"video_{i+1}_metadata.json")
                with open(metadata_file, 'w') as f:
                    json.dump({
                        'title': video.title,
                        'url': video.watch_url,
                        'search_term': search_term
                    }, f, indent=2)
                    
            except (VideoUnavailable, RegexMatchError) as e:
                print(f"Error downloading video: {str(e)}")
                continue
    
    except Exception as e:
        print(f"Pytube download failed: {str(e)}")
        
        # Method 2: Try with youtube-dl or yt-dlp as backup
        try:
            # Check if yt-dlp is available
            subprocess.run(["yt-dlp", "--version"], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
            subprocess.run([
                "yt-dlp",
                f"ytsearch{max_videos}:{search_term}",
                "--output", f"{output_dir}/video_%(playlist_index)s.%(ext)s",
                "--max-downloads", str(max_videos),
                "--format", "mp4"
            ])
        except FileNotFoundError:
            # Fallback to just downloading one example video
            print("Fallback: Downloading a sample exercise video")
            urls = [
                "https://www.pexels.com/download/video/3766188/",  # Knee exercise video from Pexels
                "https://www.pexels.com/download/video/5380680/"   # Another exercise video
            ]
            for i, url in enumerate(urls[:max_videos]):
                try:
                    output_path = os.path.join(output_dir, f"video_{i+1}.mp4")
                    subprocess.run(["curl", "-L", url, "-o", output_path])
                except Exception as e:
                    print(f"Failed to download sample video: {str(e)}")

def use_local_videos(video_dir, output_dir='ml/data/videos'):
    """Use local video files instead of downloading from YouTube
    
    Args:
        video_dir: Directory containing local video files
        output_dir: Directory to copy/link videos to for processing
        
    Returns:
        Path to the output directory with prepared videos
    """
    print(f"Using local videos from {video_dir}")
    
    # Create output directory if it doesn't exist
    if not os.path.exists(output_dir):
        os.makedirs(output_dir, exist_ok=True)
    
    # Get all video files from the source directory
    video_files = [f for f in os.listdir(video_dir) 
                   if f.lower().endswith(('.mp4', '.mov', '.avi', '.mkv'))]
    
    if not video_files:
        raise ValueError(f"No video files found in {video_dir}")
        
    print(f"Found {len(video_files)} video files, preparing for processing...")
    
    # Copy or link each video to the output directory with proper naming
    for idx, video_file in enumerate(video_files):
        source_path = os.path.join(video_dir, video_file)
        # Use a consistent naming pattern for further processing
        target_filename = f"local_video_{idx+1}.mp4"
        target_path = os.path.join(output_dir, target_filename)
        
        # Skip if target already exists
        if os.path.exists(target_path):
            print(f"Video {target_filename} already exists, skipping...")
            continue
        
        print(f"Preparing {idx+1}/{len(video_files)}: {video_file} → {target_filename}")
        
        # Option 1: Copy the file (uses more space but safer)
        shutil.copy2(source_path, target_path)
        
        # Option 2: Create a symbolic link (saves space but less portable)
        # os.symlink(source_path, target_path) # Uncomment to use symlinks instead
        
        # Save basic metadata
        metadata_file = os.path.join(output_dir, f"local_video_{idx+1}_meta.json")
        with open(metadata_file, 'w') as f:
            json.dump({
                'original_filename': video_file,
                'source_path': source_path,
                'data_type': 'local_video'
            }, f, indent=2)
    
    print(f"Prepared {len(video_files)} local videos for processing")
    return output_dir

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Download YouTube videos for training data')
    parser.add_argument('--search', type=str, default="knee physiotherapy exercises", 
                        help='Search term for YouTube videos')
    parser.add_argument('--max-videos', type=int, default=10, 
                        help='Maximum number of videos to download')
    args = parser.parse_args()
    
    download_videos(args.search, args.max_videos)
    print("Download completed!")