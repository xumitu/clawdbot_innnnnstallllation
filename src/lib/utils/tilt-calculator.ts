export function calculateTilt(
  event: MouseEvent | Touch,
  element: HTMLElement,
  maxRotateX = 10,
  maxRotateY = 20
): { rotateX: number; rotateY: number } {
  const rect = element.getBoundingClientRect();
  const clientX = 'clientX' in event ? event.clientX : event.touches?.[0]?.clientX || 0;
  const clientY = 'clientY' in event ? event.clientY : event.touches?.[0]?.clientY || 0;
  
  const x = (clientX - rect.left) / rect.width;
  const y = (clientY - rect.top) / rect.height;
  
  const rotateY = (x - 0.5) * maxRotateY;
  const rotateX = (0.5 - y) * maxRotateX;
  
  return { rotateX, rotateY };
}
