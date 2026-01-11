export default function Gallery({ isActive }) {
  if (!isActive) return null;

  const images = [
    "/gallery/photo1.jpg",
    "/gallery/photo2.jpg",
    "/gallery/photo3.jpg",
    "/gallery/photo4.jpg",
  ];

  return (
    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(200px, 1fr))",
        gap: "16px",
        padding: "20px",
        maxWidth: "1000px",
        margin: "0 auto",
      }}
    >
      {images.map((src, index) => (
        <img
          key={index}
          src={src}
          alt={`Memory ${index + 1}`}
          style={{
            width: "100%",
            height: "260px",
            objectFit: "cover",
            borderRadius: "16px",
            boxShadow: "0 10px 25px rgba(0,0,0,0.15)",
            transition: "transform 0.3s ease",
          }}
          onMouseOver={(e) => (e.currentTarget.style.transform = "scale(1.05)")}
          onMouseOut={(e) => (e.currentTarget.style.transform = "scale(1)")}
        />
      ))}
    </div>
  );
}
