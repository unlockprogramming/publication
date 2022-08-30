---
title: "Find Maximum Average Subarray"
date: 2022-06-30
draft: false
authors:
- bhuwanupadhyay
categories:
- Algorithms
tags:
- leetcode
- sliding-window
---

This article explains methods of solving _find maximum average of subarray_ using brute-force approach and optimized approach with sliding window pattern.

<!--more-->

## Problem

>You are given an integer array nums consisting of n elements, and an integer k.
>
> Find a contiguous subarray whose length is equal to k that has the maximum average value and return this value.
> [leetcode](https://leetcode.com/problems/maximum-average-subarray-i/)

## Visual Example

![Example](find-maximum-average-of-sub-arrays-1.svg?width=800px&height=800px)

## Brute-Force Solution

```java
class BruteForce {

    public double findMaxAverage(int[] nums, int k) {

        // To support any numbers (positives, zero, negatives)
        double maxAverage = Double.NEGATIVE_INFINITY;

        /*
            MATH: to find number of possible contiguous sub arrays
            - number of sub arrays = total number of elements - subarray size + 1
         */
        for (int i = 0; i < nums.length - k + 1; i++) {

            double currentSum = 0;

            // Calculate sum of elements in current subarray
            for (int j = i; j < i + k; j++) {
                currentSum += nums[j];
            }

            // Calculate average of elements in current subarray
            double currentAverage = currentSum / k;

            // Replace max average if current average is maximum
            maxAverage = Math.max(maxAverage, currentAverage);

        }

        return maxAverage;
    }

}
```

_Time complexity : **O(n*k)**_

Because sum of `k` elements for each contiguous subrray is evaluated for input array with `n` elements.

_Limitation_ :

The overlapping part of contiguous subarrays will be evaluated more than once times. For example: the overlapping part of `3` elements evaluated twice in subarray of size `4`.

![Example](find-maximum-average-of-sub-arrays-2.svg?width=800px&height=300px)

## How to optimize?

The improved solution for this problem is to use sliding window pattern to overcome the limitations of brute force method. The optimization steps are as follows:

- Create sliding window of k elements.
- Slide window by one element when move to the next contiguous subarray.
- In previous sum, add element which is included in the sliding window.
- In previous sum, subtract element which is going out from the sliding window.
- Calculate average of elements in the subarray by using resulting sum.

The algorithm complexity will decrease to O(n) if we do this instead of visiting through the entire subarray to find the sum.

## Optimized Solution

```java
class Optimized {

    public double findMaxAverage(int[] nums, int k) {

        // To support any numbers (positives, zero, negatives)
        double maxAverage = Double.NEGATIVE_INFINITY;
        double sum = 0;
        int start = 0;

        for (int end = 0; end < nums.length; end++) {

            //increase sum by adding the element which is included in sliding window
            sum += nums[end];

            //move sliding window forward, only if we have hit the required sliding window size of k
            if (end >= k - 1) {

                // Calculate average of elements in current sliding window
                double currentAverage = sum / k;

                // Replace max average if current average is maximum
                maxAverage = Math.max(maxAverage, currentAverage);

                //decrease sum by subtracting the element which is going out from sliding window
                sum -= nums[start];

                // move the sliding window forward
                start++;

            }

        }

        return maxAverage;
    }

}
```

## Test Cases

In order to test correctness of both approaches, we can use following junit5 paramterized tests.

```java
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.assertEquals;


class SolutionsTest {

    private static Stream<Arguments> values() {
        return Stream.of(
                Arguments.of(new int[]{1, 12, -5, -6, 50, 3}, 4, 12.75000),
                Arguments.of(new int[]{5}, 1, 5.00000),
                Arguments.of(new int[]{-1}, 1, -1.00000),
                Arguments.of(new int[]{0}, 1, 0.00000)
        );
    }

    @ParameterizedTest
    @MethodSource("values")
    void testBruteForce(int[] nums, int k, double expected) {
        double actual = new BruteForce().findMaxAverage(nums, k);
        assertEquals(expected, actual);
    }


    @ParameterizedTest
    @MethodSource("values")
    void testOptimized(int[] nums, int k, double expected) {
        double actual = new Optimized().findMaxAverage(nums, k);
        assertEquals(expected, actual);
    }

}
```

## References

- [maximum-average-subarray-i](https://leetcode.com/problems/maximum-average-subarray-i/)
- [parameterized-tests](https://junit.org/junit5/docs/current/user-guide/#writing-tests-parameterized-tests)
- [sliding-window](https://stackoverflow.com/questions/8269916/what-is-sliding-window-algorithm-examples)