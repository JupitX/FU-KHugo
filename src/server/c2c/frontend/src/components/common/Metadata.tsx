import { HelmetProvider, Helmet } from "react-helmet-async";

const Metadata = ({
    title,
    description,
}: {
    title: string;
    description: string;
}) => (
    <Helmet>
        <title>{title}</title>
        <meta name="description" content = {description}/>
    </Helmet>
);

export const AppWrapper = ({ children }: { children: React.ReactNode }) => (
    <HelmetProvider>{children}</HelmetProvider>
);

export default Metadata;