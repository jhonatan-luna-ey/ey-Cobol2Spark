import streamlit as st
from openai import OpenAI
import Cobol2Spark as chat

st.title("Conversor de Código")

col1, col2 = st.columns(2)

with col1:
    st.header("COBOL")
    text_input = st.text_area(
        "Enter COBOL code 👇",
        height = 300
    )
    if text_input:
        generation,code, usage = chat.cobol2spark(text_input)
    else:
        generation,code, usage = ("Aguardando ...","", 0)

with col2:
   st.header("PySpark")
   txt = st.text_area(
    "Output PySpark Code",
    generation,
    height = 300
    )
   st.write(code)
   st.write(usage)

# if prompt := st.chat_input():
#     # if not openai_api_key:
#     #     st.info("Please add your OpenAI API key to continue.")
#     #     st.stop()

#     st.session_state.messages.append({"role": "user", "content": prompt})
#     st.chat_message("user").write(prompt)
#     response = chat.generate()
#     msg = response.choices[0].message.content
#     st.session_state.messages.append({"role": "assistant", "content": msg})
#     st.chat_message("assistant").write(msg)