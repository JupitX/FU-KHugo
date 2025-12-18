import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import './index.css'
import App from './App.tsx'

import "swiper/swiper-bundle.css";
import "simplebar-react/dist/simplebar.min.css"
import { AppWrapper } from './components/common/Metadata.tsx';
import { ThemeProvider } from './context/ThemeContext.tsx';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <ThemeProvider>
      <AppWrapper>
        <App/>
      </AppWrapper>
    </ThemeProvider>
  </StrictMode>
);
