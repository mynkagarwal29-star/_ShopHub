# 🛍️ ShopHub

ShopHub is a full-stack e-commerce web application built with **Spring Boot**, **MySQL**, and **JSP**. It allows guests and registered users to browse categories, view product details, manage a shopping cart, check out, and pay securely online, while admins manage products, categories, orders, feedback, and users through a dedicated dashboard.

---

##  🚀 Live Demo

🔗 **[Launch ShopHub](https://ecom-shophub.onrender.com)**

[Watch the full walkthrough](#) (https://www.youtube.com/playlist?list=PLbG5Yc815t-I)


> **⚠️ Note for Demo Users**
>
> This application is deployed on Render's free tier. If the app has been inactive for a while, the first request may take **30–60 seconds (or longer)** as the service wakes up. Some pages may load more slowly during this initial startup. Once the application is awake, subsequent requests should be much faster.
---

## ✨ Features

- **User accounts** — signup, login, and profile management (BCrypt password hashing via Spring Security)
- **Product catalog** — browse categories and products, view product details
- **Shopping cart** — add/update/remove items, live cart item count across pages
- **Checkout & payments** — order checkout flow integrated with **Razorpay** for secure online payments
- **Order management** — order confirmation, order history/detail pages for users; order list and detail views for admins
- **Admin dashboard** — manage categories, products, orders, and view feedback/users
- **Feedback system** — users can submit feedback; admins can review it
- **Email notifications & OTP** — transactional emails and OTP verification via SMTP / Mailjet
- **Image hosting** — product images uploaded and served through **Cloudinary**
- **Static pages** — About, Contact Us, Privacy Policy, Terms & Conditions

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 |
| Framework | Spring Boot 3.1.5 |
| Web layer | Spring MVC + JSP (JSTL views), packaged as WAR |
| Persistence | Spring Data JPA / Hibernate |
| Database | MySQL |
| Security | Spring Security, BCrypt |
| Payments | Razorpay Java SDK |
| Email | Spring Mail (SMTP) + Mailjet SDK |
| Image storage | Cloudinary |
| Build tool | Maven (Maven Wrapper included) |
| Container | Docker (multi-stage build) |

---

## ☁️ Deployment & Infrastructure

This project is set up to run on the following managed services (all swappable via environment variables):

| Concern | Service used | Notes |
|---|---|---|
| Hosting | [Render](https://render.com/) | App deployed as a container/web service |
| Database | [TiDB Cloud](https://www.pingcap.com/tidb-cloud/) | MySQL-compatible cloud database |
| Media storage | [Cloudinary](https://cloudinary.com/) | Product image uploads & delivery |
| Email / OTP | [Mailtrap](https://mailtrap.io/) (sandbox) | Used for testing transactional email and OTP flows — emails are captured in a sandbox inbox, not delivered to real users. Swap in a production SMTP provider (e.g. SendGrid, real Mailjet account) for a live deployment. |
| Payments | [Razorpay](https://razorpay.com/) | Test mode keys recommended for local/demo use | Choose INR Net Banking, not supporting international transcations 

---

## 📁 Project Structure

```
ecom/
├── src/main/java/com/example/jpa/
│   ├── config/          # Security, Web, Cloudinary configuration
│   ├── controller/      # MVC controllers (Account, Admin, Cart, Category,
│   │                    #   Checkout, Feedback, Home, Order, Payment, Product)
│   ├── dao/              # Spring Data JPA repositories
│   ├── model/            # JPA entities (Account, Cart, CartItem, Category,
│   │                    #   Feedback, Order, OrderItem, Product)
│   ├── service/          # Business logic (Cart, Email, Feedback, Order, OTP, Payment)
│   └── EcomApplication.java
├── src/main/resources/
│   └── application.properties
├── src/main/webapp/
│   ├── WEB-INF/views/    # JSP pages (product list/detail, cart, checkout,
│   │                    #   admin dashboard, login/signup, etc.)
│   └── resources/css/
├── Dockerfile
└── pom.xml
```

---

## ✅ Prerequisites

- **Java 21**
- **Maven** (or use the included `mvnw` / `mvnw.cmd` wrapper)
- **MySQL** server (local or remote)
- Accounts/API keys for the integrations you want to enable:
  - [Razorpay](https://razorpay.com/) (payments)
  - An SMTP provider and/or [Mailjet](https://www.mailjet.com/) (email/OTP)
  - [Cloudinary](https://cloudinary.com/) (image uploads)
- (Optional) **Docker**, if you'd rather run it in a container

---

## ⚙️ Configuration

The app is configured via `src/main/resources/application.properties`, which reads the following environment variables (with sensible local defaults where noted):

| Variable | Purpose | Default |
|---|---|---|
| `PORT` | Server port | `8080` |
| `SPRING_DATASOURCE_URL` | MySQL JDBC URL | `jdbc:mysql://localhost:3306/ecom_db` |
| `SPRING_DATASOURCE_USERNAME` | MySQL username | `root` |
| `SPRING_DATASOURCE_PASSWORD` | MySQL password | `root` |
| `RAZORPAY_KEY_ID` | Razorpay API key ID | — |
| `RAZORPAY_KEY_SECRET` | Razorpay API secret | — |
| `MAIL_HOST` | SMTP host | — |
| `MAIL_PORT` | SMTP port | `587` |
| `FROM_EMAIL` | "From" address for outgoing mail | — |
| `MAIL_USERNAME` | SMTP username | — |
| `MAIL_PASSWORD` | SMTP password | — |
| `MAIL_SMTP_AUTH` | Enable SMTP auth | `true` |
| `MAIL_SMTP_STARTTLS` | Enable STARTTLS | `true` |
| `cloudinary.cloud-name` / `cloudinary.api-key` / `cloudinary.api-secret` | Cloudinary credentials | — |
| `SPRING_PROFILES_ACTIVE` | Active Spring profile | `default` |

> ⚠️ **Note:** The Cloudinary properties in `application.properties` currently reference placeholder keys (`${your_cloud_name}`, etc.) rather than proper environment variable placeholders — you'll likely want to update these to `${CLOUDINARY_CLOUD_NAME}` style variables (matching how Razorpay/Mail are done) before deploying.

Create a `.env` file, export these variables in your shell, or set them in your deployment platform before running the app.

---

## 🚀 Getting Started

### 1. Clone the repository
```bash
git clone https://github.com/mynkagarwal29-star/_ShopHub.git
cd _ShopHub/ecom
```

### 2. Set up MySQL
Create a database (matching `SPRING_DATASOURCE_URL`, default `ecom_db`):
```sql
CREATE DATABASE ecom_db;
```
Tables are auto-created/updated on startup (`spring.jpa.hibernate.ddl-auto=update`).

### 3. Configure environment variables
Set the variables listed in the [Configuration](#️-configuration) section above — at minimum the datasource credentials; add Razorpay/Mail/Cloudinary keys to enable those features.

### 4. Run the application
Using the Maven wrapper:
```bash
./mvnw spring-boot:run
```
Or build and run the WAR directly:
```bash
./mvnw clean package -DskipTests
java -jar target/ecom-0.0.1-SNAPSHOT.war
```

The app will start on `http://localhost:8080` (or the port set via `PORT`).

### 5. (Optional) Run with Docker
```bash
docker build -t shophub -f ecom/Dockerfile ecom
docker run -p 8080:8080 --env-file .env shophub
```

---

## 🖥️ Key Pages

| Page | Description |
|---|---|
| `/` | Home page |
| Product listing / detail | Browse categories and view individual products |
| Cart & Checkout | Add items to cart, review, and pay via Razorpay |
| Login / Signup | Account creation and authentication |
| Profile | User profile and order history |
| Feedback / Contact Us | Submit feedback or contact messages |
| Admin dashboard | Manage products, categories, orders, and view feedback |

---

## 🧪 Testing

```bash
./mvnw test
```

---

## 📄 License

No license file is currently included in this repository. Add one (e.g., MIT, Apache 2.0) if you intend to open-source this project.

---

## 🙌 Contributing

Issues and pull requests are welcome. Please open an issue first to discuss any significant changes.
