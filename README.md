# Projektowanie regulatora stanu metodą przesuwania biegunów

Celem ćwiczenia jest nabycie przez studentów wiedzy i umiejętności w zakresie:
- projektowania regulatora stanu,
- wyznaczania macierzy wzmocnień regulatora stanu metoda przesuwania biegunów (ang. pole placement/
pole assignment technique),
- zastosowania metody Ackermanna do obliczenia macierzy wzmocnień regulatora stanu,
- badania obiektów i układów regulacji w przestrzeni stanu,
- określania wpływu położenia biegunów na właściwości układu zamkniętego.

Wnioski: 

- Jeśli układ jest sterowalny, to można go ustabilizować za pomocą regulatora stanu.
- Do przesuwania biegunów układu SISO wykorzystuje się funkcję acker, a układu MIMO funkcję place.
- Zastosowanie kompensacji uchybu N powoduje zredukowanie uchybu statycznego do 0.
- Układ z całkowaniem Ki jest odporny na zakłócenia i daje najlepsze efekty regulacji.
- Schematy układów regulacji wygodniej wykonuje się w Simulinku, natomiast macierze stanu łatwiej zapisuje się w  Control Toolboxie, skąd można je w łatwy sposób zaimportować do Simulinka. Odpowiedzi układów w Simulinku i Control Toolboxie są identyczne, ponieważ bazują na tych samych danych.
- Właściwości dynamiczne układu zależą od położenia jego biegunów na płaszczyźnie zespolonej. 
- Częstotliwości własne układu to częstotliwości przy jakich układ może wpaść w rezonans. Współczynnik tłumienia określa zachowanie modelu. Dla każdego z biegunów obliczane są oddzielne współczynniki. Jeżeli współczynnik tłumienia jest równy 1 to układ powraca do równowagi bez oscylacji i jest to najszybsze dążenie do równowagi bez oscylacji. Jeżeli współczynnik jest ułamkiem to układ oscyluje ze zmniejszającą się wykładniczo amplitudą i częstością mniejszą od częstości układu nietłumionego. Wzrost tłumienia powoduje szybszy zanik amplitudy oraz zmniejszenie częstości drgań układu.

