# python/llama_server/server.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import torch
from transformers import AutoTokenizer, AutoModelForCausalLM
import uvicorn

app = FastAPI(title="PhysioFlow LLaMA API")

# Model configuration
MODEL_PATH = "path/to/your/llama/model"  # Update this

class TextRequest(BaseModel):
    prompt: str
    max_tokens: int = 256
    temperature: float = 0.7

@app.on_event("startup")
async def load_model():
    global tokenizer, model
    try:
        print("Loading Me-LLaMA model...")
        tokenizer = AutoTokenizer.from_pretrained(MODEL_PATH)
        model = AutoModelForCausalLM.from_pretrained(
            MODEL_PATH, 
            torch_dtype=torch.float16, 
            device_map="auto"
        )
        print("Model loaded successfully!")
    except Exception as e:
        print(f"Error loading model: {e}")
        raise

@app.post("/generate")
async def generate_text(request: TextRequest):
    try:
        # Prepare exercise-specific prompt
        exercise_prompt = f"""As a physiotherapy AI assistant for PhysioFlow, 
        provide guidance on the following: {request.prompt}"""
        
        # Generate response
        inputs = tokenizer(exercise_prompt, return_tensors="pt").to(model.device)
        outputs = model.generate(
            inputs.input_ids,
            max_new_tokens=request.max_tokens,
            temperature=request.temperature,
            do_sample=True,
        )
        
        response = tokenizer.decode(outputs[0], skip_special_tokens=True)
        # Extract just the generated part (remove the prompt)
        response = response[len(exercise_prompt):]
        
        return {"generated_text": response.strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Generation error: {str(e)}")

@app.post("/analyze_exercise")
async def analyze_exercise(request: TextRequest):
    """Analyze exercise form based on description"""
    try:
        analysis_prompt = f"""As a physiotherapy expert, analyze the following 
        exercise form and provide feedback: {request.prompt}
        
        Consider:
        1. Proper joint alignment
        2. Movement range
        3. Potential compensation patterns
        4. Safety concerns
        
        Provide detailed feedback:
        """
        
        # Generate analysis
        inputs = tokenizer(analysis_prompt, return_tensors="pt").to(model.device)
        outputs = model.generate(
            inputs.input_ids,
            max_new_tokens=request.max_tokens,
            temperature=request.temperature,
            do_sample=True,
        )
        
        analysis = tokenizer.decode(outputs[0], skip_special_tokens=True)
        analysis = analysis[len(analysis_prompt):]
        
        return {"analysis": analysis.strip()}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Analysis error: {str(e)}")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)