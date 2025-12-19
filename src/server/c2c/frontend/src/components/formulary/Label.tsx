import type { FC, ReactNode } from "react";
import { twMerge } from "tailwind-merge"

interface LabelProperties {
    htmlFor?: string;
    children: ReactNode;
    className?: string;
}

const Label: FC<LabelProperties> = ({ htmlFor, children, className }) => {
    return (

        <label htmlFor={htmlFor} className={twMerge("mb-1.5 block text-sm font-medium text-gray-700 dark:text-gray-400", className)}>
            {children}
        </label>

    );
};

export default Label;