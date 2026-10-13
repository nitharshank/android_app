# Android Malware Detector — Mobile App

Native Android (Kotlin) client that pairs with the FastAPI backend.

## How it works

1. User taps **Pick APK File** → system file picker opens.
2. The selected APK is copied to app cache and uploaded as `multipart/form-data`
   to `POST /predict` on the backend.
3. Backend extracts Drebin features with Androguard and runs the ensemble.
4. App receives JSON, renders verdict + per-model breakdown + APK metadata.

## Setup

1. Open `android_app/` in **Android Studio Hedgehog or newer**.
2. Let Gradle sync (it will pull all dependencies).
3. Set the backend URL — open `app/build.gradle.kts` and edit:

   ```kotlin
   buildConfigField("String", "BASE_URL", "\"http://10.0.2.2:8000/\"")
   ```

   - **Emulator on the same laptop**: leave as `http://10.0.2.2:8000/`
   - **Physical phone on Wi-Fi**: change to `http://<laptop-LAN-IP>:8000/`,
     e.g. `http://192.168.1.42:8000/`

4. Make sure the backend is running (`uvicorn main:app --host 0.0.0.0 --port 8000`).
5. Run the app from Android Studio.

## Project structure

```
app/src/main/java/com/example/malwaredetector/
├── api/
│   ├── ApiClient.kt        Retrofit + OkHttp setup
│   ├── MalwareApi.kt       Endpoint definitions
│   └── UploadHelper.kt     URI -> multipart conversion
├── model/
│   └── ApiModels.kt        Serializable response classes
└── ui/
    └── MainActivity.kt     Single-screen UI controller
```

## Why cleartext HTTP is allowed

`network_security_config.xml` whitelists `10.0.2.2`, `localhost`, and common
LAN ranges so the dev backend can be reached over plain HTTP. Strip that file
and switch to HTTPS before shipping.

## Common issues

| Symptom                              | Fix                                                        |
|--------------------------------------|------------------------------------------------------------|
| `CLEARTEXT communication not permitted` | Backend host not in `network_security_config.xml`       |
| `Connection refused` on emulator     | Use `10.0.2.2`, not `localhost` or `127.0.0.1`             |
| Connection times out on physical phone | Phone and laptop on different networks, or laptop firewall blocking 8000 |
| `404` on `/predict`                  | Make sure `BASE_URL` ends with a trailing slash            |
| `Invalid JSON` / parse errors        | Backend returned an error — check `logcat` HTTP body       |
