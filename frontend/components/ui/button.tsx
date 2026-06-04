import * as React from 'react';

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  /**
   * Visual style variant. Adjust as needed in your design system.
   * `primary` – filled accent button
   * `outline` – border only
   */
  variant?: 'primary' | 'outline';
  /** Additional class names for custom styling */
  className?: string;
}

/**
 * Simple reusable button component that matches the project's Tailwind setup.
 * It defaults to the `primary` variant with rounded corners and a smooth
 * hover transition. You can extend this component with more variants or
 * theming logic as the UI grows.
 */
export const Button: React.FC<ButtonProps> = ({
  variant = 'primary',
  className = '',
  children,
  ...rest
}) => {
  const baseStyles = 'px-4 py-2 rounded-md transition-colors disabled:opacity-50 disabled:cursor-not-allowed';
  const variantStyles =
    variant === 'primary'
      ? 'bg-indigo-600 text-white hover:bg-indigo-700 dark:bg-indigo-500 dark:hover:bg-indigo-600'
      : 'border border-gray-300 bg-white text-gray-800 hover:bg-gray-50 dark:border-gray-600 dark:bg-gray-800 dark:text-gray-100 dark:hover:bg-gray-700';

  return (
    <button className={`${baseStyles} ${variantStyles} ${className}`} {...rest}>
      {children}
    </button>
  );
};
