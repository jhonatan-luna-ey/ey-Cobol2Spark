import os
from openai import AzureOpenAI
from tqdm import tqdm
import numpy as np
import re

client = AzureOpenAI(
  azure_endpoint = "https://caecoai0jiaoa01.openai.azure.com/", 
  api_key= "14cb551b1ce5493084f689735ac91281",  
  api_version="2024-02-15-preview"
)

message_text = [{"role":"system","content":"You're an expert software engineer specialized in Cobol and PySpark programming languages. your responsibility is translate Cobol codes into PySpark accurately and including all Proccess."}]

def generate(prompt,temperature=0.7,max_tokens=1000):
    message_text.append({"role":"user","content":prompt})
    completion = client.chat.completions.create(
    model="EY_FSO_ChatTest", # model = "deployment_name"
    messages = message_text,
    temperature=temperature,
    max_tokens=max_tokens,
    top_p=0.95,
    frequency_penalty=0,
    presence_penalty=0,
    stop=None
    )
    return completion


def process_input(text_input):
    clean_input = []
    divisions = ["ENVIRONMENT DIVISION", "DATA DIVISION","PROCEDURE DIVISION"]
    data_split = text_input.split('DIVISION')[2:]
    for i,row in enumerate(data_split):
      clean_input.append(f'{divisions[i]} {row}')
    return clean_input



def generate_spark_code(input_text):
  usage = []
  responses = []
  for code in tqdm(input_text):
      response = generate(prompt=f"""Given the following code snippet. Your role will be to decipher the code, create an equivalent PySpark code with the same functionality, including all the necessary processes.

  code:
  ```
  {code}
  ```

Your task is to do the following steps:

1. Analyze and comprehend the COBOL code snippet above.
2. Write an equivalent PySpark code.
3. The equivalent code should provide the exact same output as the COBOL code.
4. Follow best practices while crafting your code, like writing clean, well-indented, efficient, and concise code.
5. Pay extra attention in the every data processing steps like filtering, aggregation, and sorting.
6. Return only the PySpark code.
  """,temperature=0.4, max_tokens=1000)
      responses.append(response)
      usage.append(((response.usage.prompt_tokens/1000) * 0.006)+((response.usage.completion_tokens/1000) * 0.012))
  return responses,usage

def cobol2spark(cobol_code):
    cobol_code = process_input(cobol_code)
    responses,usage = generate_spark_code(cobol_code)
    sparks = []
    # for resp in  responses:
    #     code = '\n\n'.join(re.findall(r'```python\n(.*?)```', resp.choices[0].message.content, re.DOTALL))
    #     sparks.append(code) 
    final_sparks = '\n\n\n '.join(responses)
    
    return final_sparks,np.sum(usage)
