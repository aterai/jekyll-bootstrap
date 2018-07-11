---
layout: post
category: swing
folder: DisableOnBoundaryValues
title: JSpinnerの値が境界値になった場合、ArrowButtonを無効にする
tags: [JSpinner, ArrowButton, LookAndFeel, UIManager]
author: aterai
pubdate: 2018-06-25T16:59:19+09:00
description: JSpinnerの値が上限または下限になった場合、対応するArrowButtonを無効にしてクリック不可にします。
image: https://drive.google.com/uc?id=17ihoEGjXqC5qVXXM1yWqjYO93QjilZQHRw
comments: true
---
## 概要
`JSpinner`の値が上限または下限になった場合、対応する`ArrowButton`を無効にしてクリック不可にします。

{% download https://drive.google.com/uc?id=17ihoEGjXqC5qVXXM1yWqjYO93QjilZQHRw %}

## サンプルコード
<pre class="prettyprint"><code>UIManager.put("Spinner.disableOnBoundaryValues", Boolean.TRUE);
</code></pre>


## 解説
- `UIManager.put("Spinner.disableOnBoundaryValues", Boolean.FALSE)`
    - 境界値になっても`ArrowButton`は有効だが、値は変更されない
    - `MetalLookAndFeel`、`NimbusLookAndFeel`、`WindowsLookAndFeel`などでのデフォルト
- `UIManager.put("Spinner.disableOnBoundaryValues", Boolean.TRUE)`
    - 境界値になると`ArrowButton`は無効になり、クリック不可で値は変更されない
    - `GTKLookAndFeel`でのデフォルト
    - `MetalLookAndFeel`の場合のみ？、起動中に切替可能

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JSliderでマウスドラッグによる値の変更が可能な範囲を制限する](https://ateraimemo.com/Swing/DragLimitedSlider.html)

<!-- dummy comment line for breaking list -->

## コメント
