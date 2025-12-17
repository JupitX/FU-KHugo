import { BrowserRouter as Router, Routes, Route } from "react-router";
import StatisticsChart from "./components/metrics/StatisticsChart";
import { ScrollToTop } from "./components/common/ScrollToTop";
import NotificationDropdown from "./components/header/NotificationDropdown";
import UserDropdown from "./components/header/UserDropdown";
import { ThemeToggler } from "./components/common/ThemeToggler";
import AppHeader from "./layout/AppHeader";
import Sidebar from "./layout/Sidebar";
import AppLayout from "./layout/AppLayout";
import Home from "./pages/Dashboard/Home";
import MonthlyConnectionsChart from "./components/metrics/MonthlyConnectionsChart";

function App() {
  return (
    <>
      <Router>
        <ScrollToTop/>
        <Routes>
          
          <Route element={<AppLayout/>}>

            <Route index path="/" element={<Home/>}/>

          </Route>

        </Routes>
      </Router>
    </>
  );
}

export default App;