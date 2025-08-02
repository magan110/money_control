# MoneyControl - Stock Market & Financial News App

A comprehensive Flutter app similar to Moneycontrol, featuring stock market data, financial news, portfolio tracking, and market analytics.

## Features

### 🏠 Home Dashboard
- Market indices overview (Sensex, Nifty, Bank Nifty, etc.)
- Top movers (gainers/losers)
- Latest financial news
- Quick search functionality

### 📈 Markets
- Real-time stock prices and data
- Top gainers and losers
- Stock search and filtering
- Market trends and analytics

### 📰 News
- Latest financial news and updates
- Category-wise news filtering
- News from multiple sources
- Market-related articles

### 💼 Portfolio
- Track your stock investments
- Portfolio performance analytics
- Gain/loss calculations
- Investment summary

### 📋 Watchlist
- Add stocks to watchlist
- Quick access to favorite stocks
- Remove stocks with swipe gesture
- Search and add new stocks

## Screenshots

The app features:
- Clean Material Design 3 interface with blue theme
- Bottom navigation with 5 main sections
- Real-time market data display
- Interactive charts and visualizations
- News cards with source attribution
- Portfolio performance tracking

## Getting Started

### Prerequisites

- Flutter SDK (3.24.3 or later)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/magan110/money_control.git
cd money_control
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Architecture

The app follows clean architecture principles with:

- **Models**: Data models for Stock, News, Portfolio, Market Index
- **Services**: Mock data service for demonstration
- **Providers**: State management using Provider pattern
- **Screens**: UI screens for different app sections
- **Widgets**: Reusable UI components

## Dependencies

- `provider`: State management
- `http`: HTTP requests for market data
- `fl_chart`: Charts and data visualization
- `intl`: Date and currency formatting
- `sqflite`: Local SQLite database
- `webview_flutter`: WebView for news articles
- `url_launcher`: Launch external URLs

## Data Models

- **Stock**: Stock information with price, change, volume
- **NewsArticle**: News articles with title, content, source
- **PortfolioHolding**: User's stock holdings and performance
- **MarketIndex**: Market indices like Sensex, Nifty

## Features Implementation

### Market Data
- Mock data service provides realistic stock market data
- Real-time price updates simulation
- Top gainers/losers calculation
- Market index tracking

### News System
- Category-based news filtering
- Article cards with source and timestamp
- News search and discovery

### Portfolio Management
- Add/remove stock holdings
- Calculate gains/losses
- Portfolio performance metrics
- Investment tracking

### Watchlist
- Add stocks to personal watchlist
- Quick access to favorite stocks
- Swipe to remove functionality

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
