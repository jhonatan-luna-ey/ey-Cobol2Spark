# import os

# from langchain_core.messages import HumanMessage, SystemMessage
# from langchain_openai import AzureChatOpenAI

# os.environ["AZURE_OPENAI_API_KEY"] = "14cb551b1ce5493084f689735ac91281"
# os.environ["AZURE_OPENAI_ENDPOINT"] = "https://caecoai0jiaoa01.openai.azure.com/"

# model = AzureChatOpenAI(
#     api_version="2023-05-15",
#     azure_deployment="Conversor_Cobol_Pyspark",
# )


# def generate(code):
#     message = SystemMessage(
#     content="You're a Software specialist, Your Objective is to Convert a code from COBOL to PySpark, returning only the code on the output. You only onvert Code, if the user ask anything else tell that you only convert code"
#         )   
#     user = HumanMessage(
#         content= f"""Convert the following code from COBOL to PySpark, Write the beste complete code that you can without forgetting any piece of code.
#             Returning only the code with some documentation of code, without any explanation:
        
#             {code}
        
#         """
#     )
#     message =model([message,user])

#     return message.content


import os
from openai import AzureOpenAI


client = AzureOpenAI(
  azure_endpoint = "https://caecoai0jiaoa01.openai.azure.com/", 
  api_key= "14cb551b1ce5493084f689735ac91281",  
  api_version="2024-02-15-preview"
)

message_text = [{"role":"system","content":"You're an expert software engineer specialized in Cobol and PySpark programming languages. your responsibility is translate Cobol codes into PySpark accurately and including all Proccess."}]

def generate(prompt,temperature=0.7,max_tokens=150):
    message_text.append({"role":"user","content":prompt})
    completion = client.chat.completions.create(
    model="EY_FSO_ChatTest", # model = "deployment_name"
    messages = message_text,
    temperature=temperature,
    top_p=0.95,
    max_tokens=max_tokens,
    frequency_penalty=0,
    presence_penalty=0,
    stop=None
    )
    return completion