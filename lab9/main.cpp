#include <iostream>


void give_access()
{
    int result = 0;
    int age = 0;
    std::cin >> age;
    if (age >= 18)
    {
        std::cout << "Access granted";
    }
    else
    {
        std::cout << "Access denied";
    }
}

int main()
{
    give_access();
    return 0;
}