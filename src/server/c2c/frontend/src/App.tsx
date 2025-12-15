import { BrowserRouter as Router, Routes, Route } from "react-router";
import StatisticsChart from "./components/metrics/StatisticsChart";
import { ScrollToTop } from "./components/common/ScrollToTop";

function App() {
  return (
    <>
      <Router>
        <ScrollToTop/>
        <Routes>
          <Route element={}>

          </Route>
        </Routes>
      </Router>
    </>
  );
}

export default App;