---
layout: post
category: swing
folder: ToolTipManager
title: ToolTip表示の切り替え
tags: [ToolTipManager, JToolTip]
author: aterai
pubdate: 2004-05-10T06:09:52+09:00
description: ツールチップ(ツールヒント)表示の有無をToolTipManagerで切り替えます。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVq857V2I/AAAAAAAAAoA/yRQeWtxd-78/s800/ToolTipManager.png
comments: true
---
## 概要
ツールチップ(ツールヒント)表示の有無を`ToolTipManager`で切り替えます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTVq857V2I/AAAAAAAAAoA/yRQeWtxd-78/s800/ToolTipManager.png %}

## サンプルコード
<pre class="prettyprint"><code>ToolTipManager.sharedInstance().setEnabled(true);
</code></pre>

## 解説
上記のサンプルでは、`JButton#setToolTipText(...)`でボタンにツールチップテキストを設定し、表示するかどうかを`ToolTipManager`を使って切り替えています。

- コンポーネントに`setToolTipText(...)`メソッドで`null`以外が設定された場合、「表示する」がデフォルト
- `ToolTipManager`は、アプリケーション全体でのツールチップの表示時間、表示までの遅延時間などが設定可能
- `ToolTipManager.sharedInstance().unregisterComponent(c)`で特定のコンポーネント`c`を`ToolTipManager`から削除可能
    - `setToolTipText(...)`を設定している場合でもツールチップは表示されない

<!-- dummy comment line for breaking list -->

## 参考リンク
- [ToolTipManager (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/ToolTipManager.html)

<!-- dummy comment line for breaking list -->

## コメント
