import { useState } from "react";

const ChartTab: React.FC = () => {
    const [selected, setSelected] = useState<"monthly" | "quarterly" | "annually">("monthly");

    const getButtonClass = (option: "monthly" | "quarterly" | "annually") =>
        selected === option
            ? "shadow-theme-sx text-gray-900 dark:text-white bg-white dark:bg-gray-800"
            : "text-gray-500 dark:text-gray-400";

    return (
        <div className = "flex items-center gap-0.5 rounded-lg bg-gray-100 p-0.5 dark:bg-gray-900">
            <button
                onClick = {() => setSelected("monthly")}
                className = {`px-3 py-2 font-medium w-full rounded-md text-theme-sm hover:text-gray-900 dark:hover:text-white ${getButtonClass("monthly")}`}
            >Monthly</button>
            <button
                onClick = {() => setSelected("quarterly")}
                className = {`px-3 py-2 font-medium w-full rounded-md text-theme-sm hover:text-gray-900 dark:hover:text-white ${getButtonClass("quarterly")}`}
            >Quarterly</button>
            <button
                onClick = {() => setSelected("annually")}
                className = {`px-3 py-2 font-medium w-full rounded-md text-theme-sm hover:text-gray-900 dark:hover:text-white ${getButtonClass("annually")}`}
            >Annually</button>
        </div>
    );
}

export default ChartTab;