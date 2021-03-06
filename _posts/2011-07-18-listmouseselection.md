---
layout: post
category: swing
folder: ListMouseSelection
title: JListをマウスクリックのみで複数選択する
tags: [JList, MouseListener]
author: aterai
pubdate: 2011-07-18T17:21:18+09:00
description: JListをアイテムをマウスクリックだけで複数選択できるように設定します。
image: https://lh6.googleusercontent.com/-wj2xm8BlBbA/TiPrjr1sQ5I/AAAAAAAAA_c/NiXO891B5fs/s800/ListMouseSelection.png
hreflang:
    href: https://java-swing-tips.blogspot.com/2012/04/select-multiple-items-in-jlist-by.html
    lang: en
comments: true
---
## 概要
`JList`をアイテムをマウスクリックだけで複数選択できるように設定します。

{% download https://lh6.googleusercontent.com/-wj2xm8BlBbA/TiPrjr1sQ5I/AAAAAAAAA_c/NiXO891B5fs/s800/ListMouseSelection.png %}

## サンプルコード
<pre class="prettyprint"><code>JList list = new JList(model) {
  private ClearSelectionListener listener;
  @Override public void setSelectionInterval(int anchor, int lead) {
    if (anchor == lead &amp;&amp; lead &gt;= 0 &amp;&amp; anchor &gt;= 0) {
      if (listener.isDragging) {
        addSelectionInterval(anchor, anchor);
      } else if (!listener.isInCellDragging) {
        if (isSelectedIndex(anchor)) {
          removeSelectionInterval(anchor, anchor);
        } else {
          addSelectionInterval(anchor, anchor);
        }
        listener.isInCellDragging = true;
      }
    } else {
      super.setSelectionInterval(anchor, lead);
    }
  }
};
</code></pre>

## 解説
- 左: `Default`
    - <kbd>Ctrl</kbd>キーを押しながらマウスクリックで複数選択可能
- 中: `MouseEvent`
    - `JList#processMouseEvent`, `JList#processMouseMotionEvent`をオーバーライドして、常に<kbd>Ctrl</kbd>キーが押されている状態に設定
    - マウスでアイテムをドラッグしても選択状態は変化しない
    - `JList`の空白部分をクリックした場合、アイテムの選択状態は変更せず(`MouseEvent#consume()`)、フォーカスだけ`JList`に移動
    - 参考: [Swing - JList where mouse click acts like ctrl-mouse click](https://community.oracle.com/thread/1351452)

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>JList list = new JList(model) {
  @Override protected void processMouseMotionEvent(MouseEvent e) {
    super.processMouseMotionEvent(convertMouseEvent(e));
  }
  @Override protected void processMouseEvent(MouseEvent e) {
    if (e.getID() == MouseEvent.MOUSE_PRESSED &amp;&amp;
        !getCellBounds(0, getModel().getSize() - 1).contains(e.getPoint())) {
      e.consume();
      requestFocusInWindow();
    } else {
      super.processMouseEvent(convertMouseEvent(e));
    }
  }
  private MouseEvent convertMouseEvent(MouseEvent e) {
    //Swing - JList where mouse click acts like ctrl-mouse click
    //https://community.oracle.com/thread/1351452
    return new MouseEvent(
        (Component) e.getSource(),
        e.getID(), e.getWhen(),
        //e.getModifiers() | InputEvent.CTRL_MASK,
        //select multiple objects in OS X: Command+click
        //pointed out by nsby
        e.getModifiers() | Toolkit.getDefaultToolkit().getMenuShortcutKeyMask(),
        e.getX(), e.getY(),
        e.getXOnScreen(), e.getYOnScreen(),
        e.getClickCount(),
        e.isPopupTrigger(),
        e.getButton());
  }
};
</code></pre>

- 右: `SelectionInterval`
    - `JList#setSelectionInterval`をオーバーライドして、ひとつのアイテムのセルを選択した場合は、`JList#addSelectionInterval`、`JList#removeSelectionInterval`を使用するように変更
    - マウスでアイテム上をドラッグすると、選択状態になる
    - ひとつのアイテムのセル内でのドラッグでは、選択状態を変更しない
    - 参考: [Swing - Re: JList where mouse click acts like ctrl-mouse click](https://community.oracle.com/thread/1351452#5694413)
    - `JList`の空白部分をクリックした場合、アイテムの選択状態をすべてクリア([JListの選択を解除](https://ateraimemo.com/Swing/ClearSelection.html))

<!-- dummy comment line for breaking list -->

## 参考リンク
- [Swing - JList where mouse click acts like ctrl-mouse click](https://community.oracle.com/thread/1351452)
- [JListの選択を解除](https://ateraimemo.com/Swing/ClearSelection.html)
- [JListのセルにJCheckBoxを使用する](https://ateraimemo.com/Swing/CheckBoxCellList.html)

<!-- dummy comment line for breaking list -->

## コメント
- `OSX(snow leopard)`では、`MouseEvent`は複数選択が出来ません。キーボードを使っても(<kbd>command</kbd>+クリック)無理でした。 -- *nsby* 2011-07-20 (水) 13:15:30
    - ご指摘ありがとうございます。`OSX`では「<kbd>command</kbd>+クリック」で複数選択でしたっけ？ `InputEvent.CTRL_MASK`決め打ちではなく、`Toolkit.getDefaultToolkit().getMenuShortcutKeyMask()`に修正した方がいいのかもしれません(ソースなどを更新しましたが、正常に動作するかは確認していません…)。 -- *aterai* 2011-07-20 (水) 19:33:29
- `Web Start`でもう一度実行してみましたが、やはり出来ませんでした。`MouseEvent`で複数選択ha -- *nsby* 2011-07-22 (金) 15:59:14
- あ、変な所で切れてしまいました。すみません。あらためて、`MouseEvent`で複数選択出来るのは、<kbd>Shift</kbd>+クリックで選択した場合のみです。それ意外はダメでした。(<kbd>Ctrl</kbd>+クリックとかでもダメ) -- *nsby* 2011-07-22 (金) 16:02:20
    - `Web Start`のキャッシュは、…関係なさそうですね。`src.zip`をダウンロードして`JList#processMouseEvent(...)`内で、`System.out.println(e);`したり`super.processMouseEvent(convertMouseEvent(e));`だけにしてみるとどうなるでしょうか？ -- *aterai* 2011-07-24 (日) 07:58:36
- `MouseEvent e`を出力してみました。ちゃんと処理してるように見えるんですが・・・

<!-- dummy comment line for breaking list -->

<pre class="prettyprint"><code>Toolkit.getDefaultToolkit().getMenuShortcutKeyMask() : 0x04 InputEvent.CTRL_MASK : 0x02
[ただのクリック]
java.awt.event.MouseEvent[MOUSE_PRESSED,(57,4),absolute(971,484),button=1,modifiers=Button1,extModifiers=Button1,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,alignmentY
=0.0,border=,flags=50331944,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFactory$Sy
stemColorProxy[r=39,g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x10

java.awt.event.MouseEvent[MOUSE_RELEASED,(57,4),absolute(971,484),button=1,modifiers=Button1,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,alignmentY=0.0,border=,flags=5
0331944,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=39,
g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x10

java.awt.event.MouseEvent[MOUSE_CLICKED,(57,4),absolute(971,484),button=1,modifiers=Button1,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,alignmentY=0.0,border=,flags=50
331944,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=39,g
=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x10

[Cntl + クリック]
java.awt.event.MouseEvent[MOUSE_PRESSED,(57,40),absolute(971,520),button=1,modifiers=?+Button1,extModifiers=?+Button1,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,align
mentY=0.0,border=,flags=50332008,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFacto
ry$SystemColorProxy[r=39,g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x12

java.awt.event.MouseEvent[MOUSE_RELEASED,(57,40),absolute(971,520),button=1,modifiers=?+Button1,extModifiers=?,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,alignmentY=0
.0,border=,flags=50332008,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFactory$Syst
emColorProxy[r=39,g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x12

java.awt.event.MouseEvent[MOUSE_CLICKED,(57,40),absolute(971,520),button=1,modifiers=?+Button1,extModifiers=?,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,alignmentY=0.
0,border=,flags=50332008,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFactory$Syste
mColorProxy[r=39,g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x12

[Command + クリック]
java.awt.event.MouseEvent[MOUSE_PRESSED,(56,72),absolute(970,552),button=1,modifiers=?+Button1+Button3,extModifiers=?+Button1,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0
.0,alignmentY=0.0,border=,flags=50332008,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaIm
ageFactory$SystemColorProxy[r=39,g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x14

java.awt.event.MouseEvent[MOUSE_RELEASED,(56,72),absolute(970,552),button=1,modifiers=?+Button1+Button3,extModifiers=?,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,alig
nmentY=0.0,border=,flags=50332008,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFact
ory$SystemColorProxy[r=39,g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x14

java.awt.event.MouseEvent[MOUSE_CLICKED,(56,72),absolute(970,552),button=1,modifiers=?+Button1+Button3,extModifiers=?,clickCount=1] on example.MainPanel$1[,0,0,106x193,alignmentX=0.0,align
mentY=0.0,border=,flags=50332008,maximumSize=,minimumSize=,preferredSize=,fixedCellHeight=-1,fixedCellWidth=-1,horizontalScrollIncrement=-1,selectionBackground=com.apple.laf.AquaImageFacto
ry$SystemColorProxy[r=39,g=118,b=218],selectionForeground=com.apple.laf.AquaImageFactory$SystemColorProxy[r=255,g=255,b=255],visibleRowCount=8,layoutOrientation=0] e.getModifiers() : 0x14
</code></pre>

- ちなみに `e.getModifiers() | Toolkit.getDefaultToolkit().getMenuShortcutKeyMask(),`を`e.getModifiers() | 0x01`, `#0x01`は <kbd>Shift</kbd>とかに無理矢理するとクリックだけで<kbd>Shift</kbd>と同じ動作になるんですけどね・・・。もう意味が分かりません。 -- *nsby* 2011-07-27 (水) 10:52:51
- あら見づらくなりすみません。 -- *nsby* 2011-07-27 (水) 10:54:02
- ようするに、`convertMouseEvent`内の`e.getModifiers()`に`0x02/0x04`を`or`しても`OSX`では無視されてるようです。なぜなんでしょう？ -- *nsby* 2011-07-27 (水) 10:58:53
    - ログ(勝手にすこし整形しました)どうもです。たしかにうまくいっているっぽいのに、不思議な感じですね。 ~~`InputEvent.CTRL_DOWN_MASK`と`InputEvent.CTRL_MASK`の違い？~~ もうすこし調べてみます。 -- *aterai* 2011-07-27 (水) 15:04:05
    - `Java 8`で修正されているかも？ [Bug ID: JDK-7170657 macosx - There seems to be no keyboard/mouse action to select non-contiguous items in List](https://bugs.openjdk.java.net/browse/JDK-7170657) -- *aterai* 2014-08-12 (火) 02:10:09
    - 追記: `Java 10`で`Toolkit#getMenuShortcutKeyMask()`(`Event.CTRL_MASK:2`を返す)は非推奨になり、[Toolkit.html#getMenuShortcutKeyMaskEx()](https://docs.oracle.com/javase/jp/10/docs/api/java/awt/Toolkit.html#getMenuShortcutKeyMaskEx%28%29)を使用すれば、例えば`Windows`環境では`InputEvent.CTRL_DOWN_MASK:128`、`macOS`環境では`InputEvent.META_DOWN_MASK`が取得できるようになった
- メモ: [Tailoring Java Applications for Mac OS X](http://developer.apple.com/jp/technotes/tn2042.html) -- *aterai* 2011-07-27 (水) 15:18:46
- ドラッグによる`JList`の複数選択は、[JListのアイテムを範囲指定で選択](https://ateraimemo.com/Swing/RubberBanding.html)を使用する方法もあります。 -- *aterai* 2012-05-30 (水) 15:18:25

<!-- dummy comment line for breaking list -->
