---
layout: post
title: BoxLayoutでリスト状に並べる
category: swing
folder: ComponentList
tags: [BoxLayout, LayoutManager]
author: aterai
comments: true
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-06-15

## BoxLayoutでリスト状に並べる
高さの異なるコンポーネントをスクロールできるようにリスト状に並べます。


{% download https://lh3.googleusercontent.com/_9Z4BYR88imo/TQTJ_UDZVaI/AAAAAAAAAVQ/BbW1hLhenS8/s800/ComponentList.png %}

### サンプルコード
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

### 解説
上記のサンプルでは、`Box.createVerticalBox`を使ってリスト状に並べています。この際、各コンポーネントの高さは変化せず、幅だけフレームサイズに追従するように、`JComponent#setMaximumSize`を設定しています。

コンポーネントの高さの合計がフレームの高さより小さい場合は、下部に余白が出来るように、最後に`Box.createVerticalGlue`を追加しています。


### コメント
- `SpringLayout`ではなく、`BoxLayout`を使うようにサンプルを変更しました。 -- [aterai](http://terai.xrea.jp/aterai.html) 2006-06-26 (月) 15:34:41
- 解説がソースと異なり、`setMinimumSize`となっていたのを`setMaximumSize`に修正。 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-05-15 (金) 22:58:16

<!-- dummy comment line for breaking list -->

