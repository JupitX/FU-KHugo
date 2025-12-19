import { BrowserRouter as Router, Routes, Route } from "react-router";
import { ScrollToTop } from "./components/common/ScrollToTop";
import AppLayout from "./layout/AppLayout";
import Home from "./pages/Dashboard/Home";
import SignIn from "./pages/Authentication/SignIn";
import NotFound from "./pages/404/NotFound";

function App() {
  return (
    <>
      <Router>
        <ScrollToTop/>
        <Routes>
          
          <Route element={<AppLayout/>}>

            <Route index path="/" element={<Home/>}/>

          </Route>

          <Route path="/signin" element={<SignIn/>}/>
          <Route path="*" element={<NotFound/>}/>

        </Routes>
      </Router>
    </>
  );
}

export default App;