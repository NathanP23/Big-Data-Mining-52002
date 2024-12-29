# Big Data Mining 52002 - MidTerm

This repository contains the MidTerm assignment for the **Big Data Mining 52002** course. Follow the steps below to set up and run the project.

---

## Setup Instructions

### 1. Clone the Repository
Clone the repository to your local machine:
```bash
git clone https://github.com/NathanP23/Big-Data-Mining-52002.git
cd Big-Data-Mining-52002/MidTerm
```

### 2. Create and Activate a Virtual Environment
Set up a Python virtual environment to isolate dependencies:
```bash
python3 -m venv venv
source venv/bin/activate  # Linux/Mac
# On Windows:
# venv\Scripts\activate
```

### 3. Install Dependencies
Install Jupyter and `ipykernel` in the virtual environment:
```bash
pip install jupyter ipykernel
python -m ipykernel install --user --name=venv --display-name "Python (venv)"
```

---

## Running the Notebook

### Option 1: Using VS Code (Preferred)
1. Open the repository in VS Code:
   ```bash
   code .
   ```
2. Open the notebook file `MidTerm_52002_2024_25.ipynb`.
3. Select the kernel:
   - In the notebook interface, choose the kernel named **Python (venv)**.
4. Click **"Run All"** to execute all cells and install the required packages using magic `%pip` commands.

---

### Option 2: Using Jupyter Notebook in a Browser
1. Start the Jupyter server:
   ```bash
   jupyter notebook MidTerm_52002_2024_25.ipynb
   ```
   or:
   ```bash
   jupyter notebook
   ```
   - The first command opens the specific notebook directly.
   - The second opens a file browser where you can manually select `MidTerm_52002_2024_25.ipynb`.

2. Ensure the kernel is set to **Python (venv)**.
3. Click **"Run All"** to execute all cells and install the required packages using magic `%pip` commands.

---

## Verifying the Setup
- **To check the Python interpreter:**
  Run the following command in a notebook cell:
  ```python
  !which python  # Linux/Mac
  !where python  # Windows
  ```
  The path should point to `venv/bin/python` (Linux/Mac) or `venv\Scripts\python` (Windows).

- **To check installed packages:**
  Run:
  ```python
  !pip list
  ```

---

## Notes
- The setup ensures all packages are installed within the virtual environment (`venv`), keeping your global Python environment clean.
- For issues or questions, feel free to reach out to the repository owner.

---

## License
This project is for educational purposes. License details can be added here if applicable.
```