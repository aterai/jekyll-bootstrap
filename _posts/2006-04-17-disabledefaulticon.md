---
layout: post
title: JFrameのアイコンを非表示
category: swing
folder: DisableDefaultIcon
tags: [JFrame, Icon]
author: aterai
---

Posted by [aterai](http://terai.xrea.jp/aterai.html) at 2006-04-17

## JFrameのアイコンを非表示
`JFrame`などのタイトルバーにあるアイコンを非表示にします。

- {% jnlp %}
- {% jar %}
- {% src %}
- {% svn %}

<!-- dummy comment line for breaking list -->

![screenshot](https://lh6.googleusercontent.com/_9Z4BYR88imo/TQTK49Ua_nI/AAAAAAAAAWs/Ipb_maWCOgY/s800/DisableDefaultIcon.png)

### サンプルコード
<pre class="prettyprint"><code>JFrame frame = new JFrame("test");
MainPanel panel = new MainPanel();
URL url = panel.getClass().getResource("16x16transparent.png");
frame.setIconImage(Toolkit.getDefaultToolkit().createImage(url));
</code></pre>

### 解説
`JFrame#setIconImage(Image)`メソッドを使用して、タイトルバーなどにあるフレームのアイコンを変更しています。

- `null`
    - デフォルトのアイコンが表示
- `new ImageIcon("").getImage();`
    - `JDK 1.5`では、アイコン非表示、`JDK 1.6`からは、デフォルトのアイコンが表示される
    - `Web Start`で起動した場合、`AccessControlException: access denied ("java.io.FilePermission" "" "read")`が発生
- `new BufferedImage(1,1,BufferedImage.TYPE_INT_ARGB);`
    - サイズが`1x1`で、透明な`Image`を表示
    - タイトルバーの左端をクリックするとタイトルメニューは表示することができる
- `toolkit.createImage(url_16x16transparent);`
    - 透過色で塗りつぶした`16x16`の`PNG`画像をアイコンとして使用
    - タイトルバーの左端をクリックするとタイトルメニューは表示することができる

<!-- dummy comment line for breaking list -->

### 参考リンク
- [Java Default Icon | Oracle Forums](https://forums.oracle.com/message/5832634)

<!-- dummy comment line for breaking list -->

### コメント
- thank u -- [mid](http://terai.xrea.jp/mid.html) 2006-06-15 (木) 17:15:20
    - np -- [aterai](http://terai.xrea.jp/aterai.html) 2009-02-05 (木) 18:10:07
- スクリーンショットなどを更新 -- [aterai](http://terai.xrea.jp/aterai.html) 2009-02-05 (木) 18:15:32

<!-- dummy comment line for breaking list -->

