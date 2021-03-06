---
layout: post
category: swing
folder: ComponentList
title: BoxLayoutでリスト状に並べる
tags: [BoxLayout, LayoutManager]
author: aterai
pubdate: 2006-06-15T19:34:32+09:00
description: 高さの異なるコンポーネントをスクロールできるようにリスト状に並べます。
image: https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ_UDZVaI/AAAAAAAAAVQ/BbW1hLhenS8/s800/ComponentList.png
comments: true
---
## 概要
高さの異なるコンポーネントをスクロールできるようにリスト状に並べます。

{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ_UDZVaI/AAAAAAAAAVQ/BbW1hLhenS8/s800/ComponentList.png %}

## サンプルコード
<pre class="prettyprint"><code>private final Box box = Box.createVerticalBox();
private final Component glue = Box.createVerticalGlue();
public void addComp(final JComponent comp) {
  comp.setMaximumSize(new Dimension(
      Short.MAX_VALUE, comp.getPreferredSize().height));
  box.remove(glue);
  box.add(Box.createVerticalStrut(5));
  box.add(comp);
  box.add(glue);
  box.revalidate();
  EventQueue.invokeLater(new Runnable() {
    @Override public void run() {
      comp.scrollRectToVisible(comp.getBounds());
    }
  });
}
</code></pre>

## 解説
上記のサンプルでは、`Box.createVerticalBox()`で作成した`Box`にコンポーネントを追加してリスト状に並べています。

- 各コンポーネントの高さは変化せず、幅だけフレームサイズに追従するように`JComponent#setMaximumSize(...)`を設定
- 各コンポーネントの高さの合計がフレームの高さより小さい場合は、下部に余白が生成されるよう末尾に`Box.createVerticalGlue()`を追加

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Box (Java Platform SE 8)](https://docs.oracle.com/javase/jp/8/docs/api/javax/swing/Box.html)

<!-- dummy comment line for breaking list -->

## コメント
- `SpringLayout`ではなく、`BoxLayout`を使うようにサンプルを変更しました。 -- *aterai* 2006-06-26 (月) 15:34:41
- 解説がソースと異なり、`setMinimumSize`となっていたのを`setMaximumSize`に修正。 -- *aterai* 2009-05-15 (金) 22:58:16

<!-- dummy comment line for breaking list -->
