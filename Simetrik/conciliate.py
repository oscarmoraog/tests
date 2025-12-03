import pandas as pd
from colorama import Fore, Style, init

init(autoreset=True)

FILE_PATH = "sample_conciliation_data.csv" 


def load_file(path):
    """
    Carga archivo detectando si el separador es ',' o '&'
    """
    try:
        df = pd.read_csv(path, sep="&")
        if len(df.columns) == 1:
            df = pd.read_csv(path)
    except:
        df = pd.read_csv(path)
    return df


def extract_month_from_skt(skt_id):
    """
    Extrae AAAA-MM desde SKT_ID formato:
    20230608-XXXXXX → 2023-06
    """
    date_part = skt_id.split("-")[0]   
    year = date_part[0:4]
    month = date_part[4:6]
    return f"{year}-{month}"


def detect_discrepancies(df):
    """
    Detecta:
    1. Fechas fuera del mes inferido desde SKT_ID
    2. Combinaciones únicas VALUE+DATE (sin match)
    """

    df["CONCILIATION_MONTH"] = df["SKT_ID"].apply(extract_month_from_skt)
    df["DATE_MONTH"] = df["DATE"].str.slice(0, 7)

    df["OUT_OF_MONTH"] = df["CONCILIATION_MONTH"] != df["DATE_MONTH"]


    grouped = (
        df.groupby(["DATE", "VALUE"])
        .agg(SKT_ID_COUNT=("SKT_ID", "count"))
        .reset_index()
    )

    grouped["MATCH_STATUS"] = grouped["SKT_ID_COUNT"].apply(
        lambda c: "NO MATCH" if c == 1 else "MATCH OK"
    )

    return df, grouped

if __name__ == "__main__":
    df = load_file(FILE_PATH)

    df, grouped = detect_discrepancies(df)

    print("\n\n========== RESUMEN DE CONCILIACIÓN ==========\n")

    for _, row in grouped.iterrows():
        date = row["DATE"]
        value = row["VALUE"]
        count = row["SKT_ID_COUNT"]
        status = row["MATCH_STATUS"]

        if status == "NO MATCH":
            print(
                f"{Fore.RED}[NO MATCH]{Style.RESET_ALL} "
                f"DATE={date} | VALUE={value} | SKT_ID_COUNT={count}"
            )
        else:
            print(
                f"{Fore.GREEN}[MATCH OK]{Style.RESET_ALL} "
                f"DATE={date} | VALUE={value} | SKT_ID_COUNT={count}"
            )

    print("\n\n========== FECHAS FUERA DEL MES ==========\n")

    outliers = df[df["OUT_OF_MONTH"] == True]

    if outliers.empty:
        print(f"{Fore.GREEN}No hay fechas fuera del mes.{Style.RESET_ALL}")
    else:
        for _, row in outliers.iterrows():
            print(
                f"{Fore.RED}[OUT OF MONTH]{Style.RESET_ALL} "
                f"SKT_ID={row['SKT_ID']} "
                f"| DATE={row['DATE']} "
                f"| DATE_MONTH={row['DATE_MONTH']} "
                f"| EXPECTED_MONTH={row['CONCILIATION_MONTH']}"
            )

    print("\n============================================\n")
