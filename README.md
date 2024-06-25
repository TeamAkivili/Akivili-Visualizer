# Akivili Platform Visualizer App

This application provides a simplified user interface for leveraging the power of CrewAI, a cutting-edge framework for orchestrating role-playing autonomous AI agents. With this app, users can streamline the process of creating and managing AI crews without the need for coding.


## Features

- **Intuitive UI**: The app offers a user-friendly interface, allowing users to easily create and manage AI crews.
- **Role-Based Agent Design**: Customize agents with specific roles, goals, and tools through a simple form-based approach.
- **Task Management**: Define tasks and assign them to agents dynamically.
- **Sequential and Hierarchical Processes**: Choose between sequential or hierarchical processes for task execution, depending on your workflow needs.
- **Save Output**: Save the output for future reference or analysis.

## Getting Started

To get started with the CrewAI Simplified App, install [PostgreSQL](https://www.postgresql.org/download/), setup PostgreSQL user and password and follow these simple steps:

For non-developers:

1. **Setup the project**: clone or download the project then run `setup_win.bat` for Windows users or `setup_linux_mac.sh` for Linux or MacOS users.

2. **Start the project**: run `start_win.bat` for Windows users or `start_linux_mac.sh` for Linux or MacOS users. ✔Finish!

For developers:

1. **Installation**: Clone the repository and install dependencies using npm or yarn:

   ```bash
   git clone https://github.com/Eng-Elias/CrewAI-Visualizer.git
   cd CrewAI-Visualizer
   npm install
   ```

2. **Create Python Virtual Enviroment**: create Python venv, activate the venv and install the requirements.

   Create venv:

   ```bash
   python -m venv venv
   ```

   To activate the virtual environment on Windows:

   ```bash
   .\venv\Scripts\activate
   ```

   To activate the virtual environment on Linux or Mac:

   ```bash
   source venv/bin/activate
   ```

   Install the requirements:

   ```bash
   pip install -r requirements.txt
   ```

3. **Configuration**: Set up your environment variables in a `.env` file:

   ```plaintext
   DATABASE_URL="postgresql://<user>:<password>@localhost:5432/crew_ai_visualizer?schema=public"

   GEMINI_API_KEY=""

   PYTHON_SITE_PACKAGES="<The  path of site packages folder in the venv you created in the previous step>"

   CREW_AI_PY_FILE="<the path of my crew_ai.py file in on your system. you can find it in src/app/api/graphql/crew_ai.py>"
   ```

4. **DB Migrations**: Run the following commands to apply database migrations:

   ```bash
   npx prisma generate
   npx prisma migrate deploy
   ```

5. **Start the Development Server**: Run the following command to start the development server:

   ```bash
   npm run dev
   ```

6. **Access the App**: Once the development server is running, access the app in your browser at `http://localhost:3000`.

## Usage

1. **Create a New Crew**: By adding agents.

2. **Customize Agents**: Fill in the information for each agent, including role, goal, backstory, tools, allow_deligation, verbose and memory.

3. **Define Missions**: Fill mission information including name, crew, verbose, process and add tasks with their details (name, description, agent, expected_output).

4. **Execute Mission**: Once your mission is set up, run it to start the execution process.

5. **View Results**: View the output of completed missions within the app.


## Tech Stack

This app is built using TypeScript, Prisma, GraphQL, Next.js, and node-calls-python to execute Python code from Node.js and get the result in addition to use ko-llama3 as LLM.


## License



