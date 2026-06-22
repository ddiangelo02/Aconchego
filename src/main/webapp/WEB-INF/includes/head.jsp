<%@page contentType="text/html" pageEncoding="UTF-8"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0" />

<script src="https://cdn.tailwindcss.com?version=3.4.5"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Kalam:wght@300;400;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded" />
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          brand: {
            'cream-lightener': '#FBF8F1',
            'cream-light': '#FDF9F2',      
            'cream-dark': '#EBE0D2',       
            'brown-dark': '#5D4037',       
            'brown-medium': '#8D6E63',     
            'brown-footer': '#AD6B49',     
            'button': '#9E7764',            
            'button-hover': '#8D6A59',      
            'green-btn': '#8A9A5B',        
            'green-btn-hover': '#7B8D4E',  
            'yellow-highlight': '#FDF5C9', 
          },
          neutral: {
            'text': '#333333',             
            'light-gray': '#E0E0E0',       
          }
        },
        fontFamily: {
          heading: ['"Kalam"', 'serif'],
          body: ['"Kalam"', 'sans-serif'], 
        },
        fontSize: {
          'display-1': ['2.5rem', { lineHeight: '1.2' }], 
          'heading-1': ['2.25rem', { lineHeight: '1.3' }], 
          'heading-2': ['1.25rem', { lineHeight: '1.4' }],  
          'base-body': ['1.25rem', { lineHeight: '1.7' }],   
          'base-body-2': ['1rem', { lineHeight: '1.4' }],   
          'price': ['1.75rem', { lineHeight: '1.2' }],     
        },
        spacing: {
          'gutter': '2rem',       
          'section-gap': '6rem',  
          'element-gap': '3rem',  
          'card-gap': '1.5rem',   
          'inner-p': '1.25rem',   
        },
      },
    },
  }
</script>
<style type="text/tailwindcss">
  @layer components {
    body {
      @apply bg-white text-brand-brown-dark font-body antialiased;
    }
    
    header p {
        @apply text-brand-brown-footer;
    }
    
    header {
        @apply bg-brand-cream-lightener;
    }
    
    .required {
        @apply text-red-500;
    }

    .section-container {
      @apply container mx-auto px-gutter mb-section-gap max-w-6xl;
    }

    .title-section {
      @apply font-heading text-heading-1 text-brand-brown-footer text-center mb-element-gap font-bold; 
    }

    .text-description {
      @apply font-body text-base-body text-brand-brown-footer font-normal leading-relaxed;
    }

    .btn-base {
      @apply font-body text-sm md:text-base px-8 py-3 rounded-lg font-medium tracking-wide transition-all duration-200 inline-block text-center shadow-sm cursor-pointer;
    }

    .btn-brown {
      @apply btn-base bg-brand-button hover:bg-brand-button-hover text-white;
    }

    .btn-green {
      @apply btn-base bg-brand-green-btn hover:bg-brand-green-btn-hover text-white;
    }

    .card-product {
      @apply rounded-2xl bg-brand-cream-light pb-4 flex flex-col items-start border border-brand-cream-dark hover:border-brand-brown-footer transition-all duration-200 relative;
    }

    .card-product-image-wrapper {
      @apply w-full aspect-square bg-gray-100 rounded-xl mb-4 flex items-center justify-center overflow-hidden relative;
    }

    .card-product-title {
      @apply font-body text-heading-2 text-brand-brown-dark font-semibold mt-2 mx-4;
    }
    
    .card-product-value {
       @apply font-body text-price font-bold text-brand-brown-footer mb-4 mx-4;
    }

    .card-plan {
      @apply rounded-2xl shadow-sm bg-white p-6 border border-neutral-light-gray flex flex-col justify-between transition-transform duration-200 hover:-translate-y-1  mx-2;
    }

    .card-plan-highlight {
      @apply card-plan bg-brand-yellow-highlight border-amber-100  mx-2;
    }

    .footer-main {
      @apply bg-brand-brown-footer text-brand-cream-light pt-16 pb-8 px-gutter font-body text-sm;
    }

    .footer-title {
      @apply font-heading text-xl font-bold text-white mb-6;
    }
  }
</style>
