import { BrowserRouter as Router, Routes, Route } from "react-router";
import { ScrollToTop } from "./components/common/ScrollToTop";
import AppLayout from "./layout/AppLayout";
import Home from "./pages/Dashboard/Home";

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