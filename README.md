# SecurityHeadersCheck

SecurityHeadersCheck is a shell script designed for checking the security headers of a website. It allows users to easily verify the presence and configuration of various security headers to enhance the security posture of their web applications.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

To use SecurityHeadersCheck, you need:

- A Unix-like operating system: macOS, Linux, etc.
- `curl` and `awk` installed on your machine.

### Installing

1. Clone the repository to your local machine:
   ```sh
   git clone https://github.com/pwnmeow/SecurityHeadersCheck.git
   ```
2. Change into the cloned directory:
   ```sh
   cd SecurityHeadersCheck
   ```
3. Make the script executable:
   ```sh
   chmod +x check.sh
   ```

## Usage

To check the security headers of a website, run:

```sh
./check.sh [website URL]
```

Replace `[website URL]` with the actual URL of the website you want to check.

For example:

```sh
./check.sh https://www.example.com
```

We can also pass custom headers for authorization to the application. 

```sh
./check.sh  https://www.example.com -H "Authorization: Bearer asasdaasdsaadsasdsasad"
```

This will display the security headers implemented by the website and any potential recommendations for improvement.

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
