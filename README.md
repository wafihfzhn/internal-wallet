# Internal Wallet API
Internal Wallet is an application designed to efficiently manage and monitor internal transactions. This application allows users to perform various financial transaction-related functions, such as balance storage, deposit, withdraw, transfer to other users, and wallet transaction history tracking.

## Tech Stack
- Ruby 3.2
- Ruby on Rails 7.2
- PostgreSQL
For a complete list of dependencies and libraries used, refer to the [Gemfile](Gemfile)

## Getting Started
Follow the steps below to set up the application on your local environment:
1. **Clone the Repository**
- Start by cloning the repository to your machine:
```bash
  git clone https://github.com/wafihfzhn/internal-wallet.git
  cd internal-wallet
```
2. **Install Dependencies**
- Install all necessary gems with:
```bash
  bundle install
```
3. **Set Up Environment Variables**
- Copy the example environment file and fill in the required values:
```bash
  cp .env.example .env
```
4. **Create the Database and Run Migrations**
- Set up the database by running:
```bash
  bundle exec rails db:create
  bundle exec rails db:migrate
```
5. **Run Tests**
- Ensure everything works correctly by running the test suite:
```bash
  bundle exec rspec
```

## Architecture Overview
The architecture of the Internal Wallet API application follows a clear and structured flow:
1. **Routes**:  Determine the endpoints and map them to their respective controllers.
2. **Controllers**: Handle process incoming requests, handle user input, and return appropriate responses.
3. **Services**: Service objects to handling business logic responsible for performing operations and processing data before interacting with the database.
4. **Queries**: Data retrieval involves multiple records or requires filtering with queries are utilized.
5. **Models**: Represent the data structure and define the relationships between different entities to interact with the database to create, read, update, and delete records.
6. **Outputs**: The outputs are formatted and returned to the end user as JSON responses.
7. **Authorization**: The application ensures secure access using **Bearer Token** for authorization. Each request to protected resources must include a valid token in the `Authorization` header:

   ```
     Authorization: Bearer <your_token_here>
   ```
With the architecture described above, hopefully to make the application more maintainable and scalable.

