import os
from openai import AzureOpenAI
import yaml
from numpy import sum


def configure_env():
  client = AzureOpenAI(
    azure_endpoint = "https://swccoai0o6aoa01.openai.azure.com/", 
    api_key= os.environ.get("OPENAI_API_KEY"),
    api_version="2024-02-15-preview"
  )
  file =  open('./prompts.yml', 'r')
  prompts = yaml.load(file, Loader=yaml.FullLoader)

  return client, prompts['cobol_conv'], prompts['pyspark_documentation']

client, cobol_conv, pyspark_documentation = configure_env()


def generate(prompt_system,prompt,temperature=0):
    message_text = [{"role":"system","content":prompt_system}]
    message_text.append({"role":"user","content":prompt})
    completion = client.chat.completions.create(
    model="Cobol2Spark", # model = "deployment_name"
    messages = message_text,
    temperature=temperature,
    top_p=0.95,
    frequency_penalty=0,
    presence_penalty=0,
    stop=None
    )
    return completion


def generate_code(cobol):
  '''
  This function generates the PySpark code from the Cobol code.

  cobol: str
    Cobol code

  return: tuple
    pyspark_code: str
      PySpark code
    documentation: str
      Documentation of the PySpark code
    usage: float
      The usage of the OpenAI API
  '''

  usage = []
  response = generate(prompt_system=cobol_conv['system_message'],
                      prompt=cobol_conv['user_message'].format(code=cobol))
  
  pyspark_code = response.choices[0].message.content
  response_documentation = generate(prompt_system=pyspark_documentation['system_message'],
                      prompt=pyspark_documentation['user_message'].format(pyspark_code=pyspark_code))
  documentation = response_documentation.choices[0].message.content
  usage.append(((response.usage.prompt_tokens/1000) * 0.01)+((response.usage.completion_tokens/1000) * 0.03))
  usage.append(((response_documentation.usage.prompt_tokens/1000) * 0.01)+((response_documentation.usage.completion_tokens/1000) * 0.03))

  return pyspark_code, documentation , sum(usage)
  