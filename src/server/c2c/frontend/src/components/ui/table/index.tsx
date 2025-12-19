import type { ReactNode } from "react";

interface TableProperties {
    children: ReactNode;
    className?: string;
}

interface TableHeaderProperties {
    children: ReactNode;
    className?: string;
}

interface TableBodyProperties {
    children: ReactNode;
    className?: string;
}

interface TableRowProperties {
    children: ReactNode;
    className?: string;
}

interface TableCellProperties {
    children: ReactNode;
    isHeader?: boolean;
    className?: string;
}

const Table: React.FC<TableProperties> = ({ children, className }) => {
    return( <table className={`min-w-full ${className}`}>{children}</table> );
};

const TableHeader: React.FC<TableHeaderProperties> = ({ children, className }) => {
    return ( <thead className={className}>{children}</thead> );
}

const TableBody: React.FC<TableBodyProperties> = ({ children, className }) => {
    return ( <tbody className={className}>{children}</tbody> )
}

const TableRow: React.FC<TableRowProperties> = ({ children, className }) => {
    return ( <tr className={className}>{children}</tr> )
}

const TableCell:React.FC<TableCellProperties> = ({ children, isHeader = false, className }) => {
    const CellTag = isHeader ? "th" : "td";

    return <CellTag className={`${className}`}>{children}</CellTag>
};

export { Table, TableHeader, TableBody, TableRow, TableCell };