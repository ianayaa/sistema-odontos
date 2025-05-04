import React, { useState, createContext } from 'react';
import Sidebar from './Sidebar';

export const SidebarCollapsedContext = createContext<{ isCollapsed: boolean; setIsCollapsed: (v: boolean) => void }>({ isCollapsed: false, setIsCollapsed: () => {} });

const DashboardLayout: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [isCollapsed, setIsCollapsed] = useState(false);
  return (
    <SidebarCollapsedContext.Provider value={{ isCollapsed, setIsCollapsed }}>
      <div className="min-h-screen flex bg-gray-50">
        <Sidebar isCollapsed={isCollapsed} setIsCollapsed={setIsCollapsed} />
        <main className="flex-1 h-screen max-h-screen overflow-y-auto p-8">
          {children}
        </main>
      </div>
    </SidebarCollapsedContext.Provider>
  );
};

export default DashboardLayout;