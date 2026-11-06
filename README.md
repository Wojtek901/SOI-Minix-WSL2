\# Środowisko SOI-Minix dla WSL2 (Windows 10 / 11)



Gotowe, zautomatyzowane środowisko laboratoryjne do przedmiotu \*\*Systemy Operacyjne (SOI.B)\*\* pozwalające na wygodną pracę z systemem \*\*Minix 2.0.3\*\* bezpośrednio pod \*\*WSL2\*\* oraz edycję kodu źródłowego w \*\*Visual Studio Code\*\* na systemie Windows.



\## Dlaczego powstało to rozwiązanie?



Domyślne jądro Linuksa dostarczane przez Microsoft w usłudze WSL2 posiada wyłączoną obsługę systemu plików Minixa (`# CONFIG\_MINIX\_FS is not set`). Uniemożliwia to bezpośrednie montowanie obrazu dysku `minix203.img` wewnątrz WSL2 i zmusza studentów do korzystania z pełnych maszyn wirtualnych (VMware/VirtualBox) oraz przesyłania plików przez przestarzałe serwery FTP/SSH.



Niniejszy pakiet rozwiązuje ten problem poprzez:

1\. Dostarczenie prekompilowanego jądra WSL2 (`bzImage`) z wbudowanym na stałe sterownikiem systemu plików Minix (`CONFIG\_MINIX\_FS=y`) oraz obsługą urządzeń pętli zwrotnej (`CONFIG\_BLK\_DEV\_LOOP=y`).

2\. Dostarczenie gotowej do zaimportowania pseudodystrybucji Linuksa z preinstalowanym emulatorem \*\*QEMU\*\*, czystym obrazem dysku \*\*Minix 2.0.3\*\*, wyodrębnionym drzewem źródeł pod \*\*VS Code\*\* (`\~/minix/workspace`) oraz zestawem komend automatyzujących pracę (`minix-run`, `minix-sync`, `minix-reset`).



\## Wybór wariantu dystrybucji



W sekcji \*\*Releases\*\* dostępne są dwa warianty systemu bazowego. Oba oferują identyczny zestaw komend automatyzujących pracę z Minixem i korzystają z tego samego jądra `bzImage`:



| Wariant obrazu | Baza | Rozmiar | Dodatkowe narzędzia | Przeznaczenie |

| :--- | :--- | :--- | :--- | :--- |

| `soi-minix-debian-lite.tar.gz` | Debian | \~593 MB | `gcc`, `g++`, `gdb`, `make`, `qemu` | Lekka paczka na cały semestr SOI.B (Minix + laboratoria C/C++ w Linuksie) |

| `soi-minix-rootfs.tar.gz` | Ubuntu 22.04 | \~690 MB | Standardowe środowisko Ubuntu + `qemu` | Klasyczne środowisko dla osób preferujących system Ubuntu |



\*Wystarczy pobrać \*\*jeden\*\* wybrany obraz `.tar.gz` (lub oba, jeśli chcesz przetestować każdy z nich – instalator wyświetli menu wyboru).\*



\## Instrukcja instalacji krok po kroku (dla początkujących)



\### Krok 1: Wymagania wstępne na czystym Windows 10 / 11



1\. \*\*Włączenie usługi WSL2:\*\*

&#x20;  Otwórz terminal \*\*PowerShell jako Administrator\*\* i wpisz:

&#x20;  ```powershell

&#x20;  wsl --install --no-distribution

&#x20;  ```

&#x20;  \*Jeśli wcześniej nie korzystałeś z WSL2, uruchom ponownie komputer po zakończeniu instalacji.\*



2\. \*\*Instalacja Visual Studio Code oraz rozszerzenia WSL:\*\*

&#x20;  \* Pobierz i zainstaluj \[Visual Studio Code](https://code.visualstudio.com/) dla systemu Windows.

&#x20;  \* Otwórz VS Code, przejdź do zakładki \*\*Extensions\*\* (`Ctrl+Shift+X`), wyszukaj wtyczkę \*\*WSL\*\* (autorstwa Microsoft) i kliknij \*\*Install\*\*.



\### Krok 2: Pobranie plików instalacyjnych



1\. Utwórz na dysku folder tymczasowy (np. `Pobrane\\SOI-Instalator`).

2\. Ze strony repozytorium pobierz skrypt \*\*`install.ps1`\*\*.

3\. Przejdź do zakładki \*\*\[Releases](../../releases)\*\* po prawej stronie repozytorium i pobierz do tego samego folderu:

&#x20;  \* plik jądra \*\*`bzImage`\*\*,

&#x20;  \* wybrany obraz dystrybucji: \*\*`soi-minix-debian-lite.tar.gz`\*\* lub \*\*`soi-minix-rootfs.tar.gz`\*\*.



\### Krok 3: Uruchomienie automatycznego instalatora



1\. Otwórz terminal \*\*PowerShell\*\* i przejdź do folderu z pobranymi plikami:

&#x20;  ```powershell

&#x20;  cd "$env:USERPROFILE\\Downloads\\SOI-Instalator"

&#x20;  ```

2\. Uruchom skrypt instalacyjny z jednorazowym pominięciem blokady wykonywania skryptów w Windows:

&#x20;  ```powershell

&#x20;  powershell -ExecutionPolicy Bypass -File .\\install.ps1

&#x20;  ```

3\. Skrypt automatycznie:

&#x20;  \* skopiuje jądro `bzImage` do `C:\\SOI-Minix\\bzImage`,

&#x20;  \* utworzy plik `%USERPROFILE%\\.wslconfig` (jeśli posiadałeś wcześniej własny plik `.wslconfig`, instalator zachowa jego kopię jako `.wslconfig.bak`),

&#x20;  \* zaimportuje wybraną pseudodystrybucję pod nazwą `SOI-Minix-Debian` lub `SOI-Minix-Ubuntu`.



\## Codzienna praca ze środowiskiem (Workflow laboratoryjny)



\### 1. Uruchomienie terminala i otwarcie kodu w VS Code



Otwórz PowerShell lub Windows Terminal i uruchom zaimportowaną dystrybucję:

```powershell

wsl -d SOI-Minix-Debian

```

\*(lub `wsl -d SOI-Minix-Ubuntu`, w zależności od wybranego wariantu).\*



Domyślne konto użytkownika to \*\*`student`\*\* (hasło: \*\*`student`\*\*, przy czym operacje montowania dysku nie wymagają podawania hasła).



Aby otworzyć katalog roboczy z kodem źródłowym Minixa w Visual Studio Code, wpisz wewnątrz terminala Linuksa:

```bash

code \~/minix/workspace

```



Struktura katalogu `\~/minix/workspace`:

\* `src/` – pełne drzewo kodu źródłowego systemu Minix 2.0.3 (odpowiada `/usr/src` w Minixie),

\* `include/` – pliki nagłówkowe systemu Minix (odpowiada `/usr/include` w Minixie),

\* `my\_tests/` – katalog na Twoje programy testowe `.c` oraz skrypty `.sh` (odpowiada `/usr/my\_tests` w Minixie).



\### 2. Dostępne komendy automatyzujące



W środowisku dostępne są trzy globalne polecenia:



\* \*\*`minix-sync`\*\* – sprawdza poprawność nazw plików, montuje obraz `minix203.img` w tle, przesyła zmodyfikowane pliki z `\~/minix/workspace` bezpośrednio na dysk Minixa i bezpiecznie odmontowuje obraz.

\* \*\*`minix-run`\*\* – automatycznie wykonuje `minix-sync`, a następnie uruchamia system Minix 2.0.3 w oknie graficznym emulatora \*\*QEMU\*\* na pulpicie Windows.

\* \*\*`minix-reset`\*\* – w razie krytycznego uszkodzenia jądra Minixa (np. brak możliwości uruchomienia systemu po błędnej modyfikacji) przywraca czysty, oryginalny obraz dysku `minix203.img` z kopii zapasowej, \*\*nie usuwając\*\* Twojego kodu z folderu `\~/minix/workspace`.



> \*\*Ważne ograniczenie systemu plików Minix 2.0.3 (limit 14 znaków):\*\*

> Oryginalny system plików Minix v1 dopuszcza nazwy plików i katalogów o długości \*\*maksymalnie 14 znaków\*\* (np. `lab1\_test.c` jest poprawne, ale `laboratorium1\_test.c` jest za długie). Skrypt `minix-sync` automatycznie weryfikuje długości nazw przed synchronizacją i ostrzeże Cię, jeśli którykolwiek plik przekroczy ten limit.



\### 3. Kompilacja jądra i zamykanie systemu wewnątrz QEMU



1\. Po uruchomieniu polecenia `minix-run` w oknie QEMU zaloguj się jako \*\*`root`\*\* (bez hasła).

2\. Jeśli modyfikowałeś pliki systemowe (np. w `src/mm` lub `src/kernel`), skompiluj nowy obraz startowy Minixa:

&#x20;  ```sh

&#x20;  cd /usr/src/tools

&#x20;  make hdboot

&#x20;  reboot

&#x20;  ```

3\. Twoje programy testowe i skrypty z folderu `workspace/my\_tests` czekają gotowe wewnątrz Minixa w katalogu:

&#x20;  ```sh

&#x20;  cd /usr/my\_tests

&#x20;  ```

4\. \*\*Zamykanie Minixa:\*\* Przed zamknięciem okna QEMU zawsze zatrzymaj system poleceniem `shutdown` (lub `halt`), aby uniknąć uszkodzenia systemu plików wewnątrz obrazu.



\## Dokumentacja techniczna (opis realizacji zadania)



\### 1. Kompilacja jądra WSL2 (`bzImage`)

Jądro zostało zbudowane na podstawie oficjalnych źródeł Microsoftu z repozytorium \[microsoft/WSL2-Linux-Kernel](https://github.com/microsoft/WSL2-Linux-Kernel) (wydawanego na licencji \*\*GNU GPLv2\*\*). W bazowym pliku konfiguracyjnym `Microsoft/config-wsl` wprowadzono następujące modyfikacje za pomocą narzędzia `scripts/config`:

\* `CONFIG\_MINIX\_FS=y` – wkompilowanie sterownika systemu plików Minix bezpośrednio w plik binarny jądra (eliminuje konieczność kopiowania zewnętrznych modułów `/lib/modules` pomiędzy dystrybucjami),

\* `CONFIG\_BLK\_DEV\_LOOP=y` – obsługa urządzeń pętli zwrotnej (`loop`) wymagana do montowania plików obrazów dysków.



Kompilację przeprowadzono celując w format `bzImage` (`make -j$(nproc) bzImage`).



\### 2. Mechanizm synchronizacji i montowania obrazu

Obraz dysku `minix203.img` jest montowany w przestrzeni użytkownika WSL2 za pomocą urządzenia pętli zwrotnej z przesunięciem (offsetem) wskazującym na początek partycji `/usr`:

```bash

sudo mount -t minix -o loop,offset=1483776 \~/minix/minix203.img \~/minix/mnt

```

Do synchronizacji drzewa źródeł zastosowano narzędzie `rsync` z flagą `--inplace`. Domyślne zachowanie `rsync` polega na tworzeniu plików tymczasowych o nazwach `.nazwa\_pliku.XXXXXX` (co dodaje 8 znaków i przekracza 14-znakowy limit wpisu katalogowego w systemie plików Minix np. dla pliku `Makefile`). Flaga `--inplace` zapisuje zmiany bezpośrednio w istniejących i-węzłach obrazu.



\### 3. Informacja licencyjna

Zmodyfikowany plik binarny jądra Linuksa (`bzImage`) podlega licencji \*\*GNU General Public License v2 (GPLv2)\*\*. Kod źródłowy jądra bazowego pochodzi z oficjalnego repozytorium `https://github.com/microsoft/WSL2-Linux-Kernel`, a pełna procedura odtworzenia kompilacji wraz ze zmienionymi flagami konfiguracyjnymi została opisana powyżej.

