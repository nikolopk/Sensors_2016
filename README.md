# Sensors_2016
A ceid project for Sensors course

Πρακτικό Κομμάτι Β
Στόχος είναι η υλοποίηση μιας ping pong εφαρμογής, η οποία θα ξεκινά και θα τερματίζεται με το user button
του TelosB mote. Θα χρησιμοποιήσετε δύο motes στα οποία θα αναθέσετε IDs 3 και 6. Αφού κάνουν boot, τα
δύο motes περιμένουν να λάβουν κάποιο πακέτο. Η εφαρμογή θα ξεκινά με το πάτημα του user button, κατά το
οποίο, το mote κάνει broadcast ένα πακέτο. Όταν το άλλο mote λάβει το πακέτο, θα φωτίζει το πρώτο και το τρίτο
LED, θα περιμένει 1 δευτερόλεπτo και στη συνέχεια θα σβήνει τα LEDs και θα κάνει με τη σειρά του broadcast το
πακέτο. Η διαδικασία θα συνεχίζεται διαδοχικά από το ένα mote στο άλλο και θα τερματίζεται όταν πατηθεί πάλι
το user button. Δοκιμάστε το για διαφορετικές αποστάσεις. Δοκιμάστε την εφαρμογή αφού αλλάξετε το εύρος
διάδοσης αλλάζοντας την κατάλληλη μεταβλητή.