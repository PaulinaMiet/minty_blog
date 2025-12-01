BEGIN TRANSACTION;
DROP TABLE IF EXISTS user;
DROP TABLE IF EXISTS post;
DROP TABLE IF EXISTS comment;
CREATE TABLE IF NOT EXISTS comment (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    author_id INTEGER NOT NULL,
    post_id INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    body TEXT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES user (id),
    FOREIGN KEY (post_id) REFERENCES post (id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS post (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    author_id INTEGER NOT NULL,
    created TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    FOREIGN KEY (author_id) REFERENCES user (id)
);
CREATE TABLE IF NOT EXISTS "user" (
	"id"	INTEGER,
	"username"	TEXT NOT NULL UNIQUE,
	"password"	TEXT NOT NULL,
	"bio"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);
INSERT INTO "comment" ("id","author_id","post_id","created","body") VALUES (1,1,1,'2025-10-29 17:00:25','Test test
');
INSERT INTO "comment" ("id","author_id","post_id","created","body") VALUES (2,1,1,'2025-10-29 17:00:36','Lorem ipsum
');
INSERT INTO "comment" ("id","author_id","post_id","created","body") VALUES (3,1,4,'2025-11-02 14:17:35','Test test
');
INSERT INTO "comment" ("id","author_id","post_id","created","body") VALUES (4,1,3,'2025-11-02 14:17:46','Lorem Ipsum
');
INSERT INTO "comment" ("id","author_id","post_id","created","body") VALUES (5,4,2,'2025-11-02 14:18:00','Lorem ipsum
');
INSERT INTO "post" ("id","author_id","created","title","body") VALUES (1,1,'2025-10-19 15:00:05','## Lorem ipsum ','Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque aliquam cursus rhoncus. Nulla eu vulputate enim, in dapibus mauris. Morbi mattis nulla eget ex fermentum, quis facilisis odio blandit. Maecenas vestibulum posuere dictum. Fusce porttitor mi sem, eget ornare metus mattis vitae. Morbi sodales porta finibus. Mauris at massa eget metus scelerisque molestie id non purus. In blandit sapien ut vestibulum lobortis. Nam mi magna, lacinia a consequat id, mollis sit amet justo. Suspendisse potenti. Suspendisse potenti. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas.

Cras in consequat nibh, at finibus dolor. Morbi in iaculis purus. Fusce vestibulum urna nec leo interdum pellentesque. Nullam sollicitudin purus et sem maximus facilisis. Nam consectetur sapien in aliquet pretium. In neque quam, laoreet efficitur consectetur eget, placerat non enim. Nullam lacinia urna eu magna interdum cursus sit amet at enim. Morbi maximus blandit malesuada. ');
INSERT INTO "post" ("id","author_id","created","title","body") VALUES (2,1,'2025-10-29 16:35:43','## Kody Informacyjne - 1xx','<p>Kody informacyjne (zaczynające się od cyfry 1) wskazują, że żądanie zostało odebrane i zrozumiane. Są one wysyłane tymczasowo, podczas gdy przetwarzanie żądania jest kontynuowane. Informują klienta o konieczności oczekiwania na ostateczną odpowiedź.</p>
            <p>Komunikat składa się tylko z linii statusu i opcjonalnych pól nagłówka oraz jest zakończony pustą linią. Ponieważ standard HTTP/1.0 nie definiował żadnych kodów stanu 1xx, serwery nie mogą wysyłać odpowiedzi 1xx do klienta zgodnego z HTTP/1.0, z wyjątkiem warunków eksperymentalnych.</p>

            <h2>Przegląd kodów informacyjnych (1xx)</h2>

            <ul>
                <li>
                    <strong><code>100 Continue</code> (Kontynuuj)</strong><br>
                    Serwer otrzymał nagłówki żądania, a klient powinien kontynuować wysyłanie treści żądania (np. w żądaniu POST). Wysyłanie dużej treści do serwera po odrzuceniu żądania z powodu nieodpowiednich nagłówków byłoby nieefektywne. Aby serwer sprawdził nagłówki, klient musi wysłać nagłówek <code>Expect: 100-continue</code> i otrzymać <code>100 Continue</code> w odpowiedzi, zanim wyśle treść.
                </li>
                <li>
                    <strong><code>101 Switching Protocols</code> (Zmiana protokołów)</strong><br>
                    Klient poprosił serwer o zmianę protokołów (np. o aktualizację z HTTP do WebSocket), a serwer zgodził się na to.
                </li>
                <li>
                    <strong><code>102 Processing</code> (Przetwarzanie) (WebDAV)</strong><br>
                    Żądanie WebDAV może zawierać wiele pod-żądań (np. operacji na plikach), co wymaga długiego czasu na ukończenie. Ten kod wskazuje, że serwer otrzymał i przetwarza żądanie, ale żadna odpowiedź nie jest jeszcze dostępna. Zapobiega to przekroczeniu limitu czasu przez klienta. (<em>Ten kod stanu jest przestarzały</em>).
                </li>
                <li>
                    <strong><code>103 Early Hints</code> (Wczesne wskazówki)</strong><br>
                    Używany do zwracania niektórych nagłówków odpowiedzi (np. wskazówek <code>Link</code>) przed wysłaniem ostatecznej wiadomości HTTP. Pozwala to przeglądarce zacząć wstępnie ładować zasoby (jak CSS czy JavaScript), podczas gdy serwer wciąż generuje pełną odpowiedź.
                </li>
            </ul>');
INSERT INTO "post" ("id","author_id","created","title","body") VALUES (3,1,'2025-10-29 16:36:17','## Kody sukcesu - 2xx','<p>Klasa kodów zaczynających się od cyfry 2 to kody sukcesu. Oznaczają one, że żądania klienta zostały przyjęte, zrozumiane i zaakceptowane. W tej klasie zawarte są poniższe kody:</p>

            <h2>Przegląd kodów sukcesu (2xx)</h2>

            <ul>
                <li>
                    <strong><code>200 OK</code></strong><br>
                    Standardowa odpowiedź na pomyślne żądania HTTP. Rzeczywista odpowiedź zależy od użytej metody żądania. W żądaniu GET odpowiedź będzie zawierać encję odpowiadającą żądanemu zasobowi. W żądaniu POST odpowiedź będzie zawierać encję opisującą lub zawierającą wynik akcji.
                </li>
                <li>
                    <strong><code>201 Created</code></strong><br>
                    Żądanie zostało zrealizowane, co spowodowało utworzenie nowego zasobu.
                </li>
                <li>
                    <strong><code>202 Accepted</code></strong><br>
                    Żądanie zostało przyjęte do przetworzenia, ale przetwarzanie nie zostało jeszcze ukończone. Żądanie może, ale nie musi, zostać ostatecznie wykonane i może zostać odrzucone w trakcie przetwarzania.
                </li>
                <li>
                    <strong><code>203 Non-Authoritative Information (od HTTP/1.1)</code></strong><br>
                    Serwer jest pośrednikiem transformującym (np. akceleratorem sieciowym), który otrzymał <code>200 OK</code> od serwera źródłowego, ale zwraca zmodyfikowaną wersję odpowiedzi źródłowej.
                </li>
                <li>
                    <strong><code>204 No Content</code></strong><br>
                    Serwer pomyślnie przetworzył żądanie i nie zwraca żadnej treści. (Idealne dla żądań DELETE).
                </li>
                <li>
                    <strong><code>205 Reset Content</code></strong><br>
                    Serwer pomyślnie przetworzył żądanie, prosi klienta o zresetowanie widoku dokumentu (np. wyczyszczenie formularza) i nie zwraca żadnej treści.
                </li>
                <li>
                    <strong><code>206 Partial Content</code></strong><br>
                    Serwer dostarcza tylko część zasobu (obsługa zakresów bajtów) z powodu nagłówka "Range" wysłanego przez klienta. Używane do wznawiania przerwanych pobierań lub dzielenia pobierania na wiele strumieni.
                </li>
                <li>
                    <strong><code>207 Multi-Status (WebDAV)</code></strong><br>
                    Treść komunikatu, która następuje, jest domyślnie komunikatem XML i może zawierać wiele oddzielnych kodów odpowiedzi, w zależności od liczby wykonanych pod-żądań.
                </li>
                <li>
                    <strong><code>208 Already Reported (WebDAV)</code></strong><br>
                    Elementy powiązania DAV zostały już wymienione w poprzedniej części odpowiedzi (multistatus) i nie są ponownie uwzględniane.
                </li>
                <li>
                    <strong><code>226 IM Used</code></strong><br>
                    Serwer zrealizował żądanie dotyczące zasobu, a odpowiedź jest reprezentacją wyniku jednej lub więcej manipulacji na instancji zastosowanych do bieżącej instancji.
                </li>
            </ul>');
INSERT INTO "post" ("id","author_id","created","title","body") VALUES (4,1,'2025-10-29 16:39:22','## Metody HTTP','<p>Zrozumienie fundamentalnych metod (czasowników) HTTP jest kluczowe dla każdego, kto pracuje z API i tworzy aplikacje internetowe. Definiują one, jaką akcję chcemy wykonać na określonym zasobie. Oto przegląd tych najważniejszych.</p>

            <h2>Najważniejsze metody HTTP</h2>

            <ul>
                <li>
                    <strong>GET</strong><br>
                    Żądanie <code>GET</code> pobiera reprezentację określonego zasobu. Żądania GET nie powinny modyfikować danych (są "bezpieczne").
                </li>
                <li>
                    <strong>POST</strong><br>
                    Żądanie <code>POST</code> przesyła dane do określonego zasobu. Często skutkuje to zmianą stanu lub utworzeniem nowego zasobu na serwerze.
                </li>
                <li>
                    <strong>PUT</strong><br>
                    Żądanie <code>PUT</code> zastępuje całą reprezentację danych określonego zasobu. Skutkuje to zmianą stanu na serwerze.
                </li>
                <li>
                    <strong>PATCH</strong><br>
                    Żądanie <code>PATCH</code> stosuje częściowe modyfikacje do zasobu. Skutkuje to zmianą stanu na serwerze (np. aktualizuje tylko jedno pole, a nie cały obiekt).
                </li>
                <li>
                    <strong>DELETE</strong><br>
                    Żądanie <code>DELETE</code> usuwa określony zasób. Skutkuje to zmianą stanu na serwerze.
                </li>
            </ul>

            <div class="info-box">
                <h3>PUT vs. POST</h3>
                <p>Chociaż akcje HTTP z grubsza odpowiadają operacjom CRUD (Create, Read, Update, Delete), nie są one tym samym. Specyfikacje techniczne tych metod nie tworzą takiego bezpośredniego połączenia i często są trudne do odczytania. Oto na przykład fragment dokumentacji RFC-9110 dotyczący rozróżnienia między POST a PUT:</p>

                <blockquote>
                    Docelowy zasób w żądaniu POST ma obsługiwać załączoną reprezentację zgodnie z własną semantyką zasobu, podczas gdy załączona reprezentacja w żądaniu PUT jest zdefiniowana jako zastępująca stan zasobu docelowego. Stąd intencja PUT jest idempotentna i widoczna dla pośredników, mimo że dokładny efekt jest znany tylko serwerowi źródłowemu.
                </blockquote>

                <p>Mówiąc prościej, żądanie <strong>POST</strong> może być obsługiwane przez serwer w dowolny sposób (np. utworzyć nowy zasób, zaktualizować istniejące), podczas gdy <strong>PUT</strong> powinno być traktowane jako "całkowite zastąpienie" zasobu. Kluczową cechą PUT jest **idempotentność** – wielokrotne wysłanie tego samego żądania PUT powinno dać ten sam rezultat, co pojedyncze wysłanie.</p>
            </div>');
INSERT INTO "user" ("id","username","password","bio") VALUES (1,'admin','admin','Lorem Ipsum');
INSERT INTO "user" ("id","username","password","bio") VALUES (4,'user','pass',NULL);
COMMIT;
