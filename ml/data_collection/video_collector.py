"""
Video collector for PhysioFlow
Fetches YouTube videos for training data
"""
from pytube import YouTube
from youtube_search import YoutubeSearch
import json
import os
import argparse

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

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Download YouTube videos for training data')
    parser.add_argument('--search', type=str, default="knee physiotherapy exercises", 
                        help='Search term for YouTube videos')
    parser.add_argument('--max-videos', type=int, default=10, 
                        help='Maximum number of videos to download')
    args = parser.parse_args()
    
    download_videos(args.search, args.max_videos)
    print("Download completed!")