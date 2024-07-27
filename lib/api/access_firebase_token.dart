import 'package:googleapis_auth/auth_io.dart';

class AccessFirebaseToken {
 static String fMessagingScope =
 "https://www.googleapis.com/auth/firebase.messaging";

 Future<String> getAccessToken() async {
 final client = await clientViaServiceAccount(
 ServiceAccountCredentials.fromJson(
{
  "type": "service_account",
  "project_id": "direct-8ed55",
  "private_key_id": "ed4ebad5e2231930abaf64f44fedc6d937252aec",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCOqnDN5iRmlxvm\nflRkBOMammLrxterpnWcdaLD4du4rebfyLzZqdOYGHE1sVKsy8B8xp4dlVtS3CnE\nyBeUnFmnnH59gE8xH/L24fiwAMbiTwyiwyoZM2cqtgHc223/OnthJN0UAYH4iYuk\nKEjaGZhwWV/jIHgvXVkJS4y579PjmOoWmabc8HviydYlqLXgSBhRyY65XenrV9Wb\ngjVcb9OvZ6KBYZPsMmMzTbwjOw7KEGbnhVEzRk+H2m5pOFiyFbTVmrtXGbKX4M0Z\ncOEk2WTMoGvtp+0GCGN4DEcvB0P5IaB7z54g7BdiiLIVHbqJdKXlMdhBOpYqqglU\nT3WTPQYlAgMBAAECggEACK5udtkOVf/T/s6pK/zwJOpIIrjS3useNQsjgG/6At7y\nMaPxef1Plu3F1dKYiVNMv0sGzB4OlJg5InRamvx4qC5ptBFewEqFamiNzYf+kj7l\nMfJWWXo7SOoSavIfW2yfnWW03kbJNeqIyNB6vmrYT93ga93J8nfntx0Vzyq85hiM\nw9aWdQ+Iz+d0yJxHwo56Y4bX9voNaVizT0h5tUOsCNkGSayL2qdMwMIq+KNcGClQ\nSjXNY0JHGCQQ/5mjlqoopCSHo6wXGKNOctSLoEnvyOp4kRiqn+XdEngyqxmn2/r9\nksfwqQ/PZA5nKk3sxdiSVMjUwE/nknODLUr9RYE7cQKBgQC/29CUk0bEVDHmbtM7\n7vBYpAsf7AMuhatUr++vpKSOD2SfjNEDtFNp+/35CMe11A1kWjlMxk8Pt8DSRbJn\n8KivT7l/snOyJ9+6SGHDycCSnBItjFxT3MbB0yqARc9sXb1VfO1SBGEcZV0K6dNP\nVZR9UQN3RQ6IP9p039Mr10Q4RwKBgQC+XHbB8PMIeccjUhyT84KRlo4xUTRyxQ6M\nOBqMBoivYYxwbEtk4BwfeJm6tOBtiImHVS/MYbB8gx9xR476wAekUOjzOJDE0e+r\n+KqPTu2tzUwolRVwCqtbx/pamVd94545Ki5WUWhJkbmya+1FNyCYs03c7oVq+T+v\nG4EAheOwMwKBgHdygT+fGbXtvUt7wCNWNWjaaNqs86YpLmwBRTaTSKfxSXJUF2U5\nBZ28d3huUPgRV20dBwOXi217t56yKcqweDT9a73m+kT2skGmAsgEedJNPLwC4RCN\nKWlO8Oz/iY4sJk5tAsvHUjZ9nRnITfjcjSAgKgo9gjitmHKfTzfCRATNAoGAYnqT\nNWHhWNEnJC6meiPPuGGazgikiXtIO2IK2cXHkHN2o/JiTp1h7yYE4YIRWJj6DPkU\n8TbYhpGPAptybGZLjcYNvUXWHvw8cUsDcX/zlaZPb+8wV/YtEB40dgo+KPJIOGqJ\n7j3PJcAtwQ/0f4o1YsnfzhvXCbBIMd6YrhyV3eECgYEAhcW1tcTXK5jlxw78NtYC\nHlWk1xu4zvQDIVdt7xPSSWw7cVkk/4LvWD+Pjy5Rx1JEdsKV4SFjRXtZEOf/mbk8\nI7z6RjU/lHG5B1JD09HLZvdVC6bKtAFcEn21EWpD5HbNcpAG0WlyZHcL7/v13FTh\nce2gcLmgjq/pcDzQQTW04xQ=\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-uvvcn@direct-8ed55.iam.gserviceaccount.com",
  "client_id": "109003914660665406565",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-uvvcn%40direct-8ed55.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
 }
),
 [fMessagingScope],
 );

 final accessToken = client.credentials.accessToken.data;
 return accessToken;
 }
}