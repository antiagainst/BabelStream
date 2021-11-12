// Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
//
// For full license terms please see the LICENSE file distributed with this
// source code

#pragma once

#include <iostream>
#include <stdexcept>
#include "Stream.h"

#define IMPLEMENTATION_STRING "STD"

template <typename N = size_t>
class ranged {
  N from, to; 
public:
  ranged(N from, N to ): from(from), to(to) {}
    class iterator {
      N num;
    public:
      using difference_type = N;
      using value_type = N;
      using pointer = const N*;
      using reference = N&;
      using iterator_category = std::random_access_iterator_tag;
      explicit iterator(N _num = 0) : num(_num) {}
      iterator& operator++() { num++; return *this; }
      iterator operator++(int) { iterator retval = *this; ++(*this); return retval; }
      bool operator==(iterator other) const { return num == other.num; }
      bool operator!=(iterator other) const { return *this != other; }
      reference operator*() const { return num;}
      difference_type operator-(const iterator &it) const { return num - it.num; }
      value_type operator[](const difference_type &i) const { return num+i; }

    };
    iterator begin() { return iterator(from); }
    iterator end() { return iterator(to >= from? to+1 : to-1); }
};

template <class T>
class STDStream : public Stream<T>
{
  protected:
    // Size of arrays
    int array_size;

    // induction range
    ranged<int> range;

    // Device side pointers
    std::vector<T> a;
    std::vector<T> b;
    std::vector<T> c;


  public:
    STDStream(const int, int) noexcept;
    ~STDStream() = default;

    virtual void copy() override;
    virtual void add() override;
    virtual void mul() override;
    virtual void triad() override;
    virtual void nstream() override;
    virtual T dot() override;

    virtual void init_arrays(T initA, T initB, T initC) override;
    virtual void read_arrays(std::vector<T>& a, std::vector<T>& b, std::vector<T>& c) override;
};

