/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{html,js,svelte,ts}'],
  theme: {
    extend: {
      colors: {
        'md-red-50': '#ffebee',
        'md-red-100': '#ffcdd2',
        'md-red-200': '#ef9a9a',
        'md-red-300': '#e57373',
        'md-red-400': '#ef5350',
        'md-red-500': '#f44336',
        'md-red-600': '#e53935',
        'md-red-700': '#d32f2f',
        'md-red-800': '#c62828',
        'md-red-900': '#b71c1c',
        'md-red-A100': '#ff8a80',
        'md-red-A200': '#ff5252',
        'md-red-A400': '#ff1744',
        'md-red-A700': '#d50000',
      },
      fontFamily: {
        'sans': ['Roboto', 'system-ui', 'sans-serif'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
  ],
}