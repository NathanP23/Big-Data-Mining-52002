# Big-Data-Mining-52002

This repository contains the code and resources for the Big Data Mining 52002 course. Follow the instructions below to set up your environment, install dependencies, and run the Jupyter notebook. 

## Prerequisites

- Python 3 installed on your system
- Git installed on your system
- If using VSCode, ensure you have Node.js and npm installed
- Jupyter Notebook (if working locally)

## Setup Instructions

### 1. Clone the Repository
Start by cloning the repository to your local machine:
```bash
git clone https://github.com/NathanP23/Big-Data-Mining-52002.git
```

### 2. Navigate to the `MidTerm` Directory
After cloning the repository, change into the `MidTerm` directory:
```bash
cd Big-Data-Mining-52002/MidTerm
```

### 3. Create a Virtual Environment
Create a virtual environment named `venv` and activate it:
- On **macOS/Linux**:
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    ```
- On **Windows**:
    ```bash
    python -m venv venv
    .\venv\Scripts\activate
    ```

### 4. Install Required Packages
With the virtual environment activated, install the necessary packages:
```bash
pip install pandas matplotlib google-cloud db-dtypes altair vl-convert-python
```

### 5. Run the Jupyter Notebook
After installing the required packages, run the Jupyter notebook:
```bash
jupyter notebook MidTerm_52002_2024_25.ipynb
```

This will open the Jupyter notebook in your default browser where you can start working with the code.

---

## Working with VSCode

If you’re using **VSCode** for your development environment, follow these additional steps:

### 1. Google CLI for VSCode Integration

To work with Google Cloud in VSCode, you need the **Google Cloud SDK**. Follow these steps to install and configure it:

1. **Install the Google Cloud SDK**:
    - Download and install the Google Cloud SDK from [here](https://cloud.google.com/sdk/docs/install).
    - Follow the installation instructions for your operating system.

2. **Authenticate with Google Cloud**:
    After installing, authenticate your account by running the following command:
    ```bash
    gcloud auth login
    ```

3. **Set Your Project ID**:
    Set your Google Cloud project to the one specified in the code:
    ```bash
    gcloud config set project big-data-mining-52002-midterm
    ```

### 2. Install the BigQuery Extension

For working with **BigQuery** in VSCode, you can use the [SQLTools BigQuery Driver](https://marketplace.visualstudio.com/items?itemName=Evidence.sqltools-bigquery-driver). Follow these steps:

1. **Install the SQLTools extension**:
    - Open VSCode and go to the Extensions view by clicking on the Extensions icon in the Activity Bar on the side of the window.
    - Search for **SQLTools BigQuery Driver** and install it.

2. **Make Sure Node.js and npm are Installed**:
    - To use the extension, make sure **Node.js** and **npm** are installed on your machine. If they are not, you can install them from [here](https://nodejs.org/).

### 3. Install db-dtypes Package

In your virtual environment, you will also need to install the `db-dtypes` package:
```bash
pip install db-dtypes
```
Then, you can import it in your code:
```python
import db_dtypes
```

### 4. Altair Rendering Setup

For **Altair** visualizations, you’ll need to enable specific renderers for your output:

- In VSCode, use:
    ```python
    import alt
    alt.renderers.enable('mimetype')
    ```

    For this, you will need to install `vl-convert-python`:
    ```bash
    pip install vl-convert-python
    ```

### 5. General Warnings Handling

To suppress warnings in your code, you can use the following:
```python
import warnings
warnings.filterwarnings('ignore')
```

---

## Working with Google Colab

If you prefer to use **Google Colab** for running the notebook, follow these steps:

### 1. Load the Repository in Google Colab

1. Open [Google Colab](https://colab.research.google.com/).
2. In the **File** menu, select **Open notebook**.
3. Go to the **GitHub** tab and paste the URL of this repository:
   ```
   https://github.com/NathanP23/Big-Data-Mining-52002
   ```
4. Select the notebook `MidTerm_52002_2024_25.ipynb` to open it in Colab.

### 2. Altair Rendering Setup in Colab

In **Google Colab**, you will need to enable the PNG renderer for Altair:
```python
import alt
alt.renderers.enable('png')
```

### 3. No Need for Additional Packages or Extensions

When working in Google Colab, you do not need to install the extensions, set up the Google Cloud CLI, or install `db-dtypes` and `vl-convert-python`. Just use the above setup for Altair rendering.

---

## Project ID and Universal Chart Settings

Throughout the code, you’ll need to define the **Google Cloud Project ID** as follows:
```python
project_id = "big-data-mining-52002-midterm"
```

Additionally, for consistent chart sizing, use the following universal settings for all charts:
```python
universal_chart_width = 850
universal_chart_height = 100
```

---

### Troubleshooting

- If you encounter any issues with dependencies, ensure your virtual environment is activated before running the installation commands.
- In Colab, if the notebook doesn’t render charts, ensure you have enabled the correct Altair renderer.

---

Let me know if you have any questions or need further assistance. Enjoy working with the project!

---