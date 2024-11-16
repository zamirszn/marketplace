remember to collect static

```
import secrets

def generate_secret_key(length=50):
    # Django's SECRET_KEY should be at least 50 characters long
    characters = 'abcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*(-_=+)'
    secret_key = ''.join(secrets.choice(characters) for _ in range(length))
    return secret_key

if __name__ == "__main__":
    print("Your new secret key is:", generate_secret_key())

```

NOTE: secure endpoint with auth
