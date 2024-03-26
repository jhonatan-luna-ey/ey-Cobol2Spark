# CodeJumper - Cobol2Spark

## Description
Este projeto tem como objetivo a criação de um compilador de código COBOL para PySpark. 
O compilador é capaz de traduzir código COBOL para código PySpark, permitindo a execução de programas COBOL em um ambiente distribuído.


## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Installation
```
python -m venv env_name

# windows
> .venv\Scripts\activate.bat            
# linux/mac 
> source .venv/bin/activate

pip install -r requirements.txt
```
## Usage
Certifique-se de que sua **OpenAI key** está corretamente configurada nas variaveis de ambiente do sistema. com nome **OPENAI_API_KEY**


Exemplo de uso:
```python

import Cobol2Spark  
resposta, documentation ,usage = Cobol2Spark.generate_code(cobol)

print(resposta)
print(documentation)
print(usage)
 
```

## Contributing

