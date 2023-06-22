# matrix_mul_module

В проекте реализуется модуль умножения матриц.

1. Написание [программы](https://github.com/AleksandrBulygin/matrix_mul_module/activecore-master/designs/rtl/sigma/sw/apps/matrix_mul/mat_mul.c) умножения матриц для процессора с архитектурой RISC-V (проект Sigma).

2. Написание [модуля](https://github.com/AleksandrBulygin/matrix_mul_module/activecore-master/designs/rtl/sigma/hw/matrix_mul.sv) и подключение его к  [UDM шине процессора](https://github.com/AleksandrBulygin/matrix_mul_module/activecore-master/designs/rtl/sigma/hw/sigma.sv).

3. Модификация [препроцессора](https://github.com/AleksandrBulygin/matrix_mul_module/activecore-master/designs/rtl/sigma_tile/hw/coproc_custom0_wrapper.sv) с целью использования расширения системы команд для ускоренного умножения матриц.

Для реализации модуля аппаратного умножения матриц использована векторно-конвейерная структура, так как полностью векторная реализация занимала больше DSP блоков, чем было в схеме ПЛИС, используемой для запуска реализованного модуля. Полные описание всех этапов изложено в [отчете](https://github.com/AleksandrBulygin/matrix_mul_module/matrix_mul.pdf).