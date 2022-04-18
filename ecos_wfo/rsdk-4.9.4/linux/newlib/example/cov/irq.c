unsigned int rlx_irq_save (void)
{
  return 1;
}

void rlx_irq_restore (unsigned int flag)
{
  (void) flag;
}
