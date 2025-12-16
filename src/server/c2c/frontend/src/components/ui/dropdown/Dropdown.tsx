import type React from "react";
import { useEffect, useRef } from "react";

interface DropdownProperties {
    isOpen: boolean;
    onClose: () => void;
    children: React.ReactNode;
    className?: string;
}

export const Dropdown: React.FC<DropdownProperties> = ({
    isOpen,
    onClose,
    children,
    className = "",
}) => {
    const dropdownReference = useRef<HTMLDivElement>(null);

    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {

            if ( dropdownReference.current && !dropdownReference.current.contains(event.target as Node) && !(event.target as HTMLElement).closest(".dropdown-toggle")) {
                onClose();
            }
        };

        document.addEventListener("mousedown", handleClickOutside);

        return () => {
            document.removeEventListener("mousedown", handleClickOutside);
        };
    }, [onClose]);

    if (!isOpen) {
        return null;
    }

    return (
        <div
            ref = {dropdownReference}
            className = { `absolute z-40 right-0 mt-2 rounded-xl border border-gray-200 bg-white shadow-theme-lg dark:border-gray-800 dark:bg-gray-dark ${className}` }
        >{children}</div>
    );
};