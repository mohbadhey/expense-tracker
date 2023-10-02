



import 'package:gsheets/gsheets.dart';

class GooglesheetsApi{

  static const _credentials = r'''

{
  "type": "service_account",
  "project_id": "expensegsheettutorial",
  "private_key_id": "b8f2f75e46164c0004f70e9168f088398dd3b013",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDLTQoUC7khDp+U\nddxYxNTne5e0zDlfvWaTB84Wej0LgDbwCbi9BjkjHyzNl8K2s4COsIpnvXXXf+ad\nIzJTCB55y/+YxUuigmfOd+rF6GnKoL3t/bBjOh9xZ3de4zcCHWh/7/1C4AWyFQHj\nD/P11B7WYTThCoWWW2NbNrj8G34CJSvkxJnYVp5jZmfmYtaY9sLZkfRhA+eth7gm\nJJrEn09VSfnRxZ50rqtmGDexlvagbWbbNnr4+Nh6pmJD6TncKEo8NvU9EuCwfkR3\nfqzp2jk3YE/VqO2NUNQ+Yv2JCeNgz2+iWiEIgJf2+irV7kchaB9tAPl9WVJgy+Eg\nT+ddjRIdAgMBAAECggEAGV/NcviOm/djCAjY3nR8vUKiCfUWcSJm39GQ0aHipiGT\n2cxg1Cjnb0CIG0YGjb6kPEsBD1cokuPaEQFQWegww5NoXLU9TjR4B99UPGzYbWu4\nIPDxt8TMoV8gWUXDOx6YCSXXRqZG17YDBQfb83INAkViL/db+osAAOW423CD/vjT\nRwy+4Tn5aPyBYF+klx5oAOI6cTfvr/ILxrMoHo1t9w0ifcg8jm4OnMD81Ov1XH9A\nF4NajySjTuozk/dNgonpPHy888/3sEID3DcstHuUZ5trSYnFUZmazZ8tUfkONGHc\n3thh2G0ww/aN2qNME+jiHfTBhmccQ6y5LrGXcHq+GQKBgQDohCkjorLl7mklU+yz\ndn32L9HbrpGWW6apu2Mg926Kf5QJysJAYGnu5B+seCrnC9GBAHbPxcmk+zqwO5se\ndDcYkKoaPofagynI9q0HixsYkKYStNYX+wlYAiUKoPId+oKlUsX49z/MYCPy/+/C\nt42MtcpoJu9eHBSXYce6nyygiQKBgQDf1YAGRQLFwGTNTon7BQWNkUbfrwv85oIW\nSc1lz91mx9vWMcnrYQc2njqPz+dYguI4EByIK8zMN3YSD7nm3RislWqWW91js1Qm\nbmhRr3O+sbvcmDYStLdHzlwK5BM6PYakb2pShwmY7DZYGM7idDLYSyI1sg/0eoP7\nPyU3zAo39QKBgQDNK1k1xaoAdDg5pO13ijYp1xZht49l0qekm+Ijw9G5yktxvIVd\n0vWGw6sjP8HzsB0ErMkqG4gL2Vd3DJGa9MdtGLHQiJ7N9PEZEHmr71ZQfcrdNM65\nyFz9WJ8g2tXqGBPSF9DzGBEmoSr3kFkbQ2ZW5E6fSsPrEfIlhjV8elohqQKBgFBG\ncbPN7ECfz4cSM8oi8uriv1hZnyMESINV1KQ++Fh0NROMp64TDlM4TChnl8DWr+sL\nXDA6BSj4ew/fM/zoLoE21RM3vx6SogtmbWNeWVR6ybVDoaDzzwehqsD9KygoCLHQ\ng4E1jOubS6Isw4XTxqhryckYI0C677qb2u038DJBAoGAQ5zO8ORRw8vA14j5TUS7\nuj5tkqjh9J9yWSuAeQuQPaQtxEaB1L6rFWymuMuNIKGibD7BQ1KGkMKlhmbmBa+v\nlIQg0qQGLrmXAh4/kpW76H7RYK2E+lCywlCC7u3viKWiJBirNbFkHpdVZ7EwDtei\nXaJ/AFwdg4gQcipFe4SywXI=\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheet-tutorial@expensegsheettutorial.iam.gserviceaccount.com",
  "client_id": "113318701909395995544",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheet-tutorial%40expensegsheettutorial.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}



''';

static const _spreadsheetId = '1VFowI-I6KI6J_o-LplBSLckwy4ZHtsdNdgaEHq6Fdyc';
static final _gsheets = GSheets(_credentials);
static Worksheet? _worksheet;

static int numberOfTransactions = 0;
static List<List<dynamic>> currentTransactions = [];
static bool loading = true;


  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }
// count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }
 // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
   // print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }
   // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'income' : 'expense',
    ]);
  }
   // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'income') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }
   // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'expense') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }

}
