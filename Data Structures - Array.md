Problem Hardness Tags:     
<code style="background:lightskyblue;color:black">EASY</code> 

<code style="background:sandybrown;color:black">MEDIUM</code>   

<code style="background:lightcoral;color:black">HARD</code>


# Arrays

### 1. Two Sum  <code style="background:lightskyblue;color:black">EASY</code>

**Question**: Given an array of integers nums and an integer target, return indices of the two numbers such that they add up to target.   
You may assume that each input would have exactly one solution, and you may not use the same element twice.   
You can return the answer in any order.   
   
**Input**: nums = [2,7,11,15], target = 9   
**Output**: [0,1]    


```python
class Solution:
    def twoSum(self, nums, target):
        seen = {} # start with empty hash table 
        
        for i,num in enumerate(nums): # enumerate returns the numbers in array as key, then their indices as values
            if target - num in seen: # if target value - num is in hash table
                return [seen[target - num], i] # return their respective indices of the target-num and i 
            seen[num] = i # if not, then put the value in the hash table 
```


```python
nums = [2,7,11,15]
target = 9
Solution().twoSum(nums, target)
```




    [0, 1]



### 53. Maximum Subarray <code style="background:lightskyblue;color:black">EASY</code> 
   
**Question**: Given an integer array nums, find the contiguous subarray (containing at least one number) which has the largest sum and return its sum.     

**Input**: nums = [-2,1,-3,4,-1,2,1,-5,4]   
**Output**: 6   
**Explanation**: [4,-1,2,1] has the largest sum = 6.   
   
There are two standard DP approaches suitable for arrays:   
- Constant space one. Move along the array and modify the array itself.   
- Linear space one. First move in the direction left->right, then in the direction right->left. Combine the results.
  


```python
# Example: nums = [-2,1,-3,4,-1,2,1,-5,4]
class Solution:
    def maxSubArray(self, nums):
        n = len(nums) # n = 9 
        max_sum = nums[0] # set first value -2 to max_sum 
        for i in range(1, n): 
            if nums[i-1] > 0: # if prev. term is greater than 0
                nums[i] += nums[i-1] # nums[i] updated with nums[i-1] + current nums[i] 
            max_sum = max(nums[i], max_sum) # update max_sum 
            
        return max_sum 
```


```python
nums = [-2,1,-3,4,-1,2,1,-5,4]
```


```python
Solution().maxSubArray(nums)
```




    6



### 121. Best Time to Buy and Sell Stock <code style="background:lightskyblue;color:black">EASY</code> 
   
**Question**: You are given an array prices where prices[i] is the price of a given stock on the ith day.   
You want to maximize your profit by choosing a single day to buy one stock and choosing a different day in the future to sell that stock.   
Return the maximum profit you can achieve from this transaction. If you cannot achieve any profit, return 0.   


```python
class Solution:
    def maxProfit(self, prices):
        max_price, min_price = 0, float('inf') # 0 as max_price, inf as min_price 
        for i in prices: 
            min_price = min(min_price, i) # min(inf, current value at ith place)
            profit = i - min_price 
            max_price = max(max_price, profit)
        return max_price 
```

- for 1st value in prices array, [7,1,5,3,6,4]   
min_price = min(inf, 7) => 7   
profit = 7-7 => 0   
max_price = max(0, 0) => 0   
    
- for 2nd value:   
min_price = min(7, 1)   
profit = 1 - 7 => -6   
max_price = max(0, -6) => 0   

**Time Complexity**: O(n). only a single pass is needed.    
**Space Complexity**: O(1). only two variables are used. 


```python
prices = [7,1,5,3,6,4] 
s = Solution()
s.maxProfit(prices)
```




    5




```python
Solution().maxProfit(prices)
```




    5



### 283. Move Zeroes <code style="background:lightskyblue;color:black">EASY</code> 

**Question**: Given an array nums, write a function to move all 0's to the end of it while maintaining the relative order of the non-zero elements.   

**Input**: [0,1,0,3,12]   
**Output**: [1,3,12,0,0]   


```python
class Solution:
    def moveZeroes(self, nums):
        """
        Do not return anything, modify nums in-place instead.
        """
        zero = 0 # records the location of the right-most 0
        for i in range(len(nums)):
            if nums[i] != 0: # if i != 0, switch their respective values 
                nums[i], nums[zero] = nums[zero], nums[i] 
                zero += 1 # updates 0's location that it has switched to 
```


```python
nums = [0,1,0,3,12]
Solution().moveZeroes(nums)
nums
```




    [1, 3, 12, 0, 0]



### 509. Fibonacci Number  <code style="background:lightskyblue;color:black">EASY</code> 

In computing, memoization or memoisation is an optimization technique used primarily to speed up computer programs by storing the results of expensive function calls and returning the cached result when the same inputs occur again.

**Question**:     
The Fibonacci numbers, commonly denoted F(n) form a sequence, called the Fibonacci sequence, such that each number is the sum of the two preceding ones, starting from 0 and 1. That is,
```
F(0) = 0, F(1) = 1
F(n) = F(n - 1) + F(n - 2), for n > 1.
```

Given n, calculate F(n).   




```python
class Solution:
    def fib(self, n):
        if n <= 1:  # if n is <= 1, then just return n 
            return n 
        return self.memoize(n) 
    
    def memoize(self, n):
        cache = {0: 0, 1: 1} # starting a cache 
        
        for i in range(2, n+1): # iterate thru 2 to n (use n+1 so that range() includes n) 
            cache[i] = cache[i-1] + cache[i-2] # store each computed answer as a new key value pair
            # use this to reference previous 2 numbers to calculate the current number 
            
        return cache[n] # when we reach last number, return Fibonacci number 
```

**Time complexity**: O(n). each number starting at 2 up to n is visited, computed, then stored for O(1) access later on.       
**Space complexity**: O(n). Size of data structure is proportionate to n. 


```python
Solution().fib(n=10)
```




    55




```python
# Bottom-Up Approach 
class Solution:
    def fib_bottom_up(self, n):
        if n == 1 or n == 2:
            return 1 
        bottom_up = [None]*(n+1) 
        bottom_up[1] = 1 
        bottom_up[2] = 1 
        
        for i in range(3, n+1):
            bottom_up[i] = bottom_up[i-1] + bottom_up[i-2] 
        return bottom_up[n]
```


```python
Solution().fib_bottom_up(n=10)
```




    55




```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```


```python

```
