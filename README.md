# 🔍 Search Analytics App

A simple Ruby on Rails 8.0.2 backend with a vanilla JavaScript frontend to track and display **search terms usage per user**. Useful for basic analytics dashboards or feature usage insights.

## Features

- Logs user search terms with timestamps
- Displays most searched terms per user
- Interactive chart using Chart.js
- API backend (Rails)
- Vanilla JavaScript frontend

---

## Tech Stack

- **Backend**: Ruby on Rails 8.0.2 (API mode)
- **Frontend**: Vanilla JS + Chart.js
- **Database**: PostgreSQL

---

## Getting Started

1. **Clone the repo**:

```bash
git clone https://github.com/omaryehia/search_analytics.git
cd search_analytics
```

2. **Install Dependencies**:
```bash
bundle install
yarn install
```

3. **Setup the database**:
```bash
rails db:create
rails db:migrate
```

4. **Run the server**:
```bash
bin/dev
```

## Running Tests
```bash
bundle exec rspec
```
