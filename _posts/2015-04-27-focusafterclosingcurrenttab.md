---
layout: post
category: swing
folder: FocusAfterClosingCurrentTab
title: JTabbedPaneで現在のタブを閉じた後に選択されるタブを変更する
tags: [JTabbedPane]
author: aterai
pubdate: 2015-04-27T00:35:47+09:00
description: JTabbedPaneでタブ選択の履歴を保存し、これを参照して現在選択されているタブを閉じた後に選択するタブを決定します。
image: https://lh3.googleusercontent.com/-_mItwH72EqU/VTy9MH6jOJI/AAAAAAAAN3A/rVSueixCerw/s800/FocusAfterClosingCurrentTab.png
comments: true
---
## 概要
`JTabbedPane`でタブ選択の履歴を保存し、これを参照して現在選択されているタブを閉じた後に選択するタブを決定します。

{% download https://lh3.googleusercontent.com/-_mItwH72EqU/VTy9MH6jOJI/AAAAAAAAN3A/rVSueixCerw/s800/FocusAfterClosingCurrentTab.png %}

## サンプルコード
<pre class="prettyprint"><code>JTabbedPane tabbedPane = new JTabbedPane() {
  private final List&lt;Component&gt; history = new ArrayList&lt;Component&gt;(5);
  @Override public void setSelectedIndex(int index) {
    super.setSelectedIndex(index);
    Component component = getComponentAt(index);
    history.remove(component);
    history.add(0, component);
  }
  @Override public void removeTabAt(int index) {
    Component component = getComponentAt(index);
    super.removeTabAt(index);
    history.remove(component);
    if (!history.isEmpty()) {
      setSelectedComponent(history.get(0));
    }
  }
};
</code></pre>

## 解説
- デフォルト(右隣りのタブに移動)
    - `JTabbedPane`で現在選択されているタブを`JTabbedPane#removeTabAt(int)`で閉じた場合、その後に選択されるタブは右隣(縦の場合は下)のタブで固定
        - 一番最後のタブが選択されていた場合は`JTabbedPane#getTabCount() - 1`
- 以前選択されていたタブに移動
    - 上記のサンプルでは、`JTabbedPane#setSelectedIndex(int)`をオーバーライドし、ここで選択の履歴を保存
    - `JTabbedPane#removeTabAt(int)`をオーバーライドし、履歴からその前に選択されていたタブを検索して選択状態を設定

<!-- dummy comment line for breaking list -->

## 参考リンク
- [JTabbedPane (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/JTabbedPane.html#getSelectedIndex--)

<!-- dummy comment line for breaking list -->

## コメント
