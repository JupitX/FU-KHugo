import { BrowserRouter as Router, Routes, Route } from "react-router";
import StatisticsChart from "./components/metrics/StatisticsChart";
import { ScrollToTop } from "./components/common/ScrollToTop";
import NotificationDropdown from "./components/header/NotificationDropdown";
import UserDropdown from "./components/header/UserDropdown";
import { ThemeToggler } from "./components/common/ThemeToggler";
import AppHeader from "./layout/AppHeader"

function App() {
  return (
    <>
      <Router>
        <ScrollToTop/>
        <Routes>
          <Route index path="/" element={<AppHeader/>}/>
        </Routes>
      </Router>
    </>
  );
}

export default App;