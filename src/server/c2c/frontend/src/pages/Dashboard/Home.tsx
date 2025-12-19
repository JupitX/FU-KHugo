import Metadata from "../../components/common/Metadata";
import StatisticsChart from "../../components/metrics/StatisticsChart";
import ConnectionMetrics from "../../components/metrics/ConnectionsMetrics";
import MonthlyConnectionsChart from "../../components/metrics/MonthlyConnectionsChart";
import MonthlyTarget from "../../components/metrics/MonthlyTarget";
import DemographicChart from "../../components/metrics/DemographicChart";
import RecentConnections from "../../components/metrics/RecentConnections";

export default function Home() {
    return (
        <>
            <Metadata
                title = "Fuckhugo C2C - Home"
                description = "This is the home page of the Fuckhugo All-In-One RAT tool"
            />

            <div className="grid grid-cols-12 gap-4 md:gap-6">
                <div className="col-span-12 space-y-6 xl:col-span-7">

                    <ConnectionMetrics/>
                    <MonthlyConnectionsChart/>

                </div>

                <div className="col-span-12 xl:col-span-5">
                    <MonthlyTarget/>
                </div>

                <div className="col-span-12">
                    <StatisticsChart/>
                </div>

                <div className="col-span-12 xl:col-span-5">
                    <DemographicChart/>
                </div>

                <div className="col-span-12 xl:col-span-7">
                    <RecentConnections/>
                </div>

            </div>

        </>
    );
}